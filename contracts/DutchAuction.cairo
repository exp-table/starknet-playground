# Declare this file as a StarkNet contract and set the required
# builtins.
%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le, is_le_felt
from starkware.cairo.common.math import assert_not_zero

from cmp import is_ge, assert_is_ge

struct Auction:
    member starting_price : felt
    member decreasing_constant : felt
    member starting_time : felt
    member duration : felt
end

@storage_var
func _auctions(auction_id : felt) -> (res : Auction):
end

@external
func setAuction{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        auction_id : felt,
        starting_price : felt,
        decreasing_constant : felt,
        starting_time : felt,
        duration : felt
    ):
    alloc_locals
    local new_auction: Auction = Auction(starting_price, decreasing_constant, starting_time, duration)
    _auctions.write(auction_id, value=new_auction)
    return ()
end

@view
func getAuction{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*,
        range_check_ptr}(auction_id : felt) -> (auction : Auction):
    let (auction) = _auctions.read(auction_id)
    return (auction)
end

@view
func getPrice{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*,
        range_check_ptr}(auction_id : felt) -> (price : felt):
    alloc_locals
    let (auction) = _auctions.read(auction_id)
    let (now) = get_block_timestamp()
    let (bool) = is_le(now, auction.starting_time)
    if bool == 1:
        return (price=auction.starting_price)
    end
    let (bool) = is_ge(now, auction.starting_time + auction.duration)
    if bool == 1:
        return(price=auction.starting_price - auction.decreasing_constant * auction.duration)
    else:
        return (price=auction.starting_price - auction.decreasing_constant * (now - auction.starting_time))
    end
end

@external
func verifyBid{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
    }(auction_id : felt) -> (price : felt):
    alloc_locals
    let (auction:Auction) = _auctions.read(auction_id)
    let (now) = get_block_timestamp()
    assert_not_zero(auction.starting_time) #check auction exists
    assert_is_ge(now, auction.starting_time) #check auction has started
    let (price) = getPrice(auction_id)
    # do some checks w.r.t. the price
    # require(msg.value >= pricePaid, "PURCHASE:INCORRECT MSG.VALUE");
    # refund the difference
    # if (msg.value - pricePaid > 0) Address.sendValue(payable(msg.sender), msg.value-pricePaid);
    return (price)
end

# TMP HACK
####################

@storage_var
func _block_timestamp() -> (res: felt):
end

@view
func get_block_timestamp{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr}() -> (block_timestamp: felt):
    let (res) = _block_timestamp.read()
    return (block_timestamp=res)
end

@external
func set_block_timestamp{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr}(new_block_timestamp: felt):
    _block_timestamp.write(new_block_timestamp)
    return ()
end
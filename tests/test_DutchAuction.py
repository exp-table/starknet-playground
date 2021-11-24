import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

@pytest.fixture(scope='module')
async def dutch_factory():
    starknet = await Starknet.empty()
    dutch = await starknet.deploy(
        "contracts/DutchAuction.cairo",
        cairo_path=["contracts"]
    )
    return starknet, dutch


# values to construct new auction
starting_price, dec_constant, starting_time, duration = 200, 1, 1000, 100
time_delta = 15

@pytest.mark.asyncio
async def test_auction_creation(dutch_factory):
    _, dutch = dutch_factory
    await dutch.setAuction(0, starting_price, dec_constant, starting_time, duration).invoke()
    executed_info = await dutch.getAuction(0).call()
    assert executed_info.result.auction == (starting_price, dec_constant, starting_time, duration)

@pytest.mark.asyncio
async def test_auction_started(dutch_factory):
    _, dutch = dutch_factory
    #set timestamp
    await dutch.set_block_timestamp(starting_time).invoke()
    executed_info = await dutch.getPrice(0).call()
    assert executed_info.result == (starting_price,)

@pytest.mark.asyncio
async def test_middle_auction(dutch_factory):
    _, dutch = dutch_factory
    #set timestamp
    await dutch.set_block_timestamp(starting_time+time_delta).invoke()
    executed_info = await dutch.getPrice(0).call()
    assert executed_info.result == (starting_price - (time_delta * dec_constant),)

@pytest.mark.asyncio
async def test_end_auction(dutch_factory):
    _, dutch = dutch_factory
    #set timestamp
    await dutch.set_block_timestamp(starting_time*2).invoke()
    executed_info = await dutch.getPrice(0).call()
    assert executed_info.result == (starting_price - (duration * dec_constant),)
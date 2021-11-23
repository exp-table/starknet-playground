from starkware.cairo.common.math_cmp import is_le_felt

# WARNING ! Naive implementation of >= ! shouldn't be used for production
func is_ge{range_check_ptr}(a:felt, b:felt) -> (res : felt):
    let (le) = is_le_felt(a+1, b)
    if le == 1:
        return (res=0)
    else:
        return (res=1)
    end
end
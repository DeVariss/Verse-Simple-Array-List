some_element<public> := class<unique>:

element_list<public> := class<final>:
    var<private> Capacity<public>: int

    var Wrapper<private>: wrapper_array = wrapper_array{}
    var Size<private>: int = 0

    block:
        set Wrapper.BackingArray = for (I := 1..Capacity) {false}

    Add<public>(Element: some_element)<transacts>: void =
        if (Size >= Capacity):
            Resize()
        (set Wrapper.BackingArray[Size] = option{Element}) or Err("Failed to append element to back of array.")
        set Size += 1

    Insert<public>(Index:int, Element: some_element)<transacts><decides>: void =
        IsValidIndex[Index]
        set Wrapper.BackingArray = Wrapper.BackingArray.Insert[Index, array{option{Element}}] or Err("Failed to insert value into array.")
        set Size += 1

    Remove<public>(Element: some_element)<transacts><decides>: some_element =
        Index := Wrapper.BackingArray.Find[option{Element}]
        FoundElement := Wrapper.BackingArray[Index]?
        set Wrapper.BackingArray = Wrapper.BackingArray.RemoveElement[Index] or Err("Failed to remove element from array.")
        set Size -= 1
        return FoundElement

    Get<public>(Index: int)<transacts><decides>: some_element =
        IsValidIndex[Index]
        return Wrapper.BackingArray[Index]?

    GetSize<public>()<transacts>: int = Wrapper.BackingArray.Length

    Resize<private>()<transacts>: void =
        set Capacity *= 2
        NewWrapper := wrapper_array{}
        set NewWrapper.BackingArray = for (I := 0..Capacity - 1):
            if (Element := Wrapper.BackingArray[I]):
                Element
            else:
                false
        set Wrapper = NewWrapper

    IsValidIndex<private>(Index: int)<transacts><decides>: void = (0 <= Index < Size) and Size > 0

wrapper_array := class:
    var BackingArray: []?some_element = array{}

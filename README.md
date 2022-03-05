# BitTools

Hierarchical Bit Array

* if we have 10000 bits = 156 uint64s = 1250 bytes = 78 indices
* the upside is that 


* we could have additional 3 uints64 which indicate if the particular uint64 has any bits set

* when we compress the array, we would skip the 
* also if a bit is set on the meta level but the block itself is zero, that could mean

* i guess we could have a compressed bit set on which would do the block thing and on top it would have another level that indicates full
* if we have a bitset with 10000 bits and they are all set, this could be compressed as 3 blocks
* a compressed array 

* iteartion over a hierarchical bitset could be faster since we are sparing ourselves

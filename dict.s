; dictionary implementation
;  - 16 bit num elements, must be power of 2 starting with 4
;  - 16 bit hash mask = num elements of bits in lower end used to mask hash codes
;  - 48 bits for each entry, 24-bit pointer to name, 24-bit pointer to value
; elements found by calling hash function on name object to give index
; then check the name at the index for equality, if not, try the next one until
; we find an empty name or we wrap around.
    !dict_offset_size = 0
    !dict_offset_mask = 2
    !dict_offset_elements = 4

;   dict_new(size: word): pointer
;       size must be a power of 2
dict_new:


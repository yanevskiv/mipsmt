#include <stdint.h>

extern uint32_t _vma_start_addr;
extern uint32_t _vma_end_addr;
extern uint32_t _lma_start_addr;	
extern uint32_t main();

void ivh_reset() {
	// copy .data from FLASH to SRAM
	register uint32_t *_lma = &_lma_start_addr;
	register uint32_t *_vma = &_vma_start_addr;
	register uint32_t *_end = &_vma_end_addr;
	while (_vma < _end) {
		*_vma = *_lma;
		_vma++;
		_lma++;
	}

	// call main func
	main();
}

void ivh_default() {
	for ( ; ; ) {
		// empty
	}
}

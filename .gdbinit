# File name:    .gdbinit
# Description:   Gdb new commands for diferent pourposes
# Version:       1.0
# Created:       2015_09_01__09:17:54
# Revision:      none
# 
# Author:        flopez, flopez@m2c-solutions.es 

#Example of command
define armex
  printf "EXEC_RETURN (LR):\n",
  info registers $lr
    if $lr & 0x4 == 0x4
    printf "Uses MSP 0x%x return.\n", $MSP
    set $armex_base = $MSP
    else
    printf "Uses PSP 0x%x return.\n", $PSP
    set $armex_base = $PSP
    end
  
    printf "xPSR            0x%x\n", *($armex_base+28)
    printf "ReturnAddress   0x%x\n", *($armex_base+24)
    printf "LR (R14)        0x%x\n", *($armex_base+20)
    printf "R12             0x%x\n", *($armex_base+16)
    printf "R3              0x%x\n", *($armex_base+12)
    printf "R2              0x%x\n", *($armex_base+8)
    printf "R1              0x%x\n", *($armex_base+4)
    printf "R0              0x%x\n", *($armex_base)
    printf "Return instruction:\n"
    x/i *($armex_base+24)
    printf "LR instruction:\n"
    x/i *($armex_base+20)
end
  
document armex
ARMv7 Exception entry behavior.
xPSR, ReturnAddress, LR (R14), R12, R3, R2, R1, and R0
end

#STM32 SPECIFIC ONES

define m3_it
  #ICSR
  set $ICSR = 0xE000ED04 
  set $VECTACTIVE  = 0x000001FF
  set $VECTPENDING = 0x0003F000
  printf "IT (ICSR) = \n"
  set $icsr = *$ICSR
  p/x $icsr 
  set $active_it = (($icsr & $VECTACTIVE) -16)
  set $next_it = ( (($icsr & $VECTPENDING)>>12) -16)
  printf "Active = %d; Next = %d\n", $active_it, $next_it


end

document m3_it
end

 #related to projects
  
  #health
define m3_ehealth_buf_plot
  printf "-----------------\n"

  printf "eeg_buffer structure:\n"
  set $entry_index = eeg_buffer.index_rx_from_dma/10
  set $out_index = eeg_buffer.index_tx_to_external/10
  printf "index_rx_from_dma = %u => buffer_pos = %u\n",  eeg_buffer.index_rx_from_dma, $entry_index 
  printf "index_tx_to_external = %u\n",  eeg_buffer.index_tx_to_external
  printf "full = %u; empty = %u\n", eeg_buffer.full, eeg_buffer.empty

  printf "  --  \n"

  printf "eeg_buffer.pre_block_array[].pre_data_XX[].data[1] \n"
  
  set $i = 0
  set $size = 30
  set $old_t = 0
  while $i < $size
    if ($i == $out_index)
      printf "(TO SD) ---> "
      else
      printf "             "
    end
    printf "%2u: ", $i
    printf "%2X %2X %2X %2X %2X ", eeg_buffer.pre_block_array[$i].pre_data_A[0].data[1], eeg_buffer.pre_block_array[$i].pre_data_A[1].data[1], eeg_buffer.pre_block_array[$i].pre_data_A[2].data[1], eeg_buffer.pre_block_array[$i].pre_data_A[3].data[1], eeg_buffer.pre_block_array[$i].pre_data_A[4].data[1]
    printf " "
    printf "%2X %2X %2X %2X %2X ", eeg_buffer.pre_block_array[$i].pre_data_B[0].data[1], eeg_buffer.pre_block_array[$i].pre_data_B[1].data[1], eeg_buffer.pre_block_array[$i].pre_data_B[2].data[1], eeg_buffer.pre_block_array[$i].pre_data_B[3].data[1], eeg_buffer.pre_block_array[$i].pre_data_B[4].data[1]
    printf " T_a = %u", time_stamp_eeg_debug_A[$i]
    printf " TS = %u", eeg_buffer.pre_block_array[$i].timestamp
    printf " d_ba = %d", ( eeg_buffer.pre_block_array[$i].timestamp - time_stamp_eeg_debug_A[$i] ) 
    printf " DELTA = %d", (eeg_buffer.pre_block_array[$i].timestamp-$old_t)
    set $old_t = eeg_buffer.pre_block_array[$i].timestamp
    if ($i == $entry_index)
      printf "  <<<====== (ENTRY POINT)"
    end
    printf "\n"
    
    set $i = $i+1
  end

  printf "  --  \n"

  printf "dma_buffer \n"
  printf "pointer = %u; space_left = %u;\n", dma_eeg_rx_buffer.rx_data_from_spi, dma_eeg_rx_buffer.rx_data_from_spi_space_left
  set $point_to = dma_eeg_rx_buffer.rx_data_from_spi

  set $i = 0
  set $size = 5
  while $i < $size
    if ($i == $point_to)
      printf "                \\/\\/\\/\\/   \n"
    end
    p/x dma_eeg_rx_buffer.dma_spi_rx_data_A[$i].eeg_data_structure.info
    set $i = $i+1
  end

  printf " - \n"

  set $point_to = $point_to - 5

  set $i = 0
  set $size = 5
  while $i < $size
    if ($i == $point_to)
      printf "   \\/\\/\\/\\/   \n"
    end
    p/x dma_eeg_rx_buffer.dma_spi_rx_data_B[$i].eeg_data_structure.info
    set $i = $i+1
  end
  
printf "  --  \n"
  
end

document m3_ehealth_buf_plot
STM32l100rc ehealth project
Shows buffer status
This function is usefull to see whole situation
end


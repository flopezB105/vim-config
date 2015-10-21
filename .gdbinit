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

#CURRENT && NEXT INTERRUPT
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

  set $it_id = 0 
  if ($active_it == $it_id)
    printf "WWDG"
    printf "\n"
  end 
  set $it_id = 1 
  if ($active_it == $it_id)
    printf "PVD"
    printf "\n"
  end 
  set $it_id = 2 
  if ($active_it == $it_id)
    printf "TAMPER_STAMP"
    printf "\n"
  end 
  set $it_id = 3 
  if ($active_it == $it_id)
    printf "RTC_WKUP"
    printf "\n"
  end 
  set $it_id = 4 
  if ($active_it == $it_id)
    printf "FLASH"
    printf "\n"
  end 
  set $it_id = 5 
  if ($active_it == $it_id)
    printf "RCC"
    printf "\n"
  end 
  set $it_id = 6 
  if ($active_it == $it_id)
    printf "EXTI0"
    printf "\n"
  end 
  set $it_id = 7 
  if ($active_it == $it_id)
    printf "EXTI1"
    printf "\n"
  end 
  set $it_id = 8 
  if ($active_it == $it_id)
    printf "EXTI2"
    printf "\n"
  end 
  set $it_id = 9 
  if ($active_it == $it_id)
    printf "EXTI3"
    printf "\n"
  end 
  set $it_id = 10 
  if ($active_it == $it_id)
    printf "EXTI4 EXTI"
    printf "\n"
  end 
  set $it_id = 11 
  if ($active_it == $it_id)
    printf "DMA1_Channel1"
    printf "\n"
  end 
  set $it_id = 12 
  if ($active_it == $it_id)
    printf "DMA1_Channel2"
    printf "\n"
  end 
  set $it_id = 13 
  if ($active_it == $it_id)
    printf "DMA1_Channel3"
    printf "\n"
  end 
  set $it_id = 14 
  if ($active_it == $it_id)
    printf "DMA1_Channel4"
    printf "\n"
  end 
  set $it_id = 15 
  if ($active_it == $it_id)
    printf "DMA1_Channel5"
    printf "\n"
  end 
  set $it_id = 16 
  if ($active_it == $it_id)
    printf "DMA1_Channel6"
    printf "\n"
  end 
  set $it_id = 17 
  if ($active_it == $it_id)
    printf "DMA1_Channel7"
    printf "\n"
  end 
  set $it_id = 18 
  if ($active_it == $it_id)
    printf "ADC1"
    printf "\n"
  end 
  set $it_id = 19 
  if ($active_it == $it_id)
    printf "USB"
    printf "\n"
  end 
  set $it_id = 20 
  if ($active_it == $it_id)
    printf "USB_LP"
    printf "\n"
  end 
  set $it_id = 21 
  if ($active_it == $it_id)
    printf "DAC"
    printf "\n"
  end 
  set $it_id = 22 
  if ($active_it == $it_id)
    printf "COMP"
    printf "\n"
  end 
  set $it_id = 23 
  if ($active_it == $it_id)
    printf "EXTI9_5"
    printf "\n"
  end 
  set $it_id = 24 
  if ($active_it == $it_id)
    printf "LCD"
    printf "\n"
  end 
  set $it_id = 25 
  if ($active_it == $it_id)
    printf "TIM9"
    printf "\n"
  end 
  set $it_id = 27 
  if ($active_it == $it_id)
    printf "TIM11"
    printf "\n"
  end 
  set $it_id = 28 
  if ($active_it == $it_id)
    printf "TIM2"
    printf "\n"
  end 
  set $it_id = 29 
  if ($active_it == $it_id)
    printf "TIM3"
    printf "\n"
  end 
  set $it_id = 30 
  if ($active_it == $it_id)
    printf "TIM4"
    printf "\n"
  end 
  set $it_id = 31 
  if ($active_it == $it_id)
    printf "I2C1_EV"
    printf "\n"
  end 
  set $it_id = 32 
  if ($active_it == $it_id)
    printf "I2C1_ER"
    printf "\n"
  end 
  set $it_id = 33 
  if ($active_it == $it_id)
    printf "I2C2_EV"
    printf "\n"
  end 
  set $it_id = 34 
  if ($active_it == $it_id)
    printf "I2C2_ER"
    printf "\n"
  end 
  set $it_id = 36 
  if ($active_it == $it_id)
    printf "SPI2"
    printf "\n"
  end 
  set $it_id = 37 
  if ($active_it == $it_id)
    printf "USART1"
    printf "\n"
  end 
  set $it_id = 38 
  if ($active_it == $it_id)
    printf "USART2"
    printf "\n"
  end 
  set $it_id = 39 
  if ($active_it == $it_id)
    printf "USART3"
    printf "\n"
  end 
  set $it_id = 40 
  if ($active_it == $it_id)
    printf "EXTI15_10"
    printf "\n"
  end 
  set $it_id = 41 
  if ($active_it == $it_id)
    printf "RTC_Alarm"
    printf "\n"
  end 
  set $it_id = 42 
  if ($active_it == $it_id)
    printf "USB_FS_WKUP"
    printf "\n"
  end 
  set $it_id = 43 
  if ($active_it == $it_id)
    printf "TIM6"
    printf "\n"
  end 
  set $it_id = 44 
  if ($active_it == $it_id)
    printf "TIM7"
    printf "\n"
  end 


end

document m3_it
end

#UART SR
define m3_uart
#PERIPH ADDR for stm32l1
    set $PERIPH_BASE = 0x40000000
    set $APB1PERIPH_BASE = $PERIPH_BASE
    set $APB2PERIPH_BASE = ($PERIPH_BASE + 0x10000)
    set $AHBPERIPH_BASE = ($PERIPH_BASE + 0x20000)

#UART BASE
    set $USART1_BASE = $APB2PERIPH_BASE + 0x3800 
    set $USART2_BASE = $APB1PERIPH_BASE + 0x4400 
    set $USART3_BASE = $APB1PERIPH_BASE + 0x4800

#UART SR
    set $USART1_SR = $USART1_BASE + 0x00
    set $USART2_SR = $USART2_BASE + 0x00
    set $USART3_SR = $USART3_BASE + 0x00

    set $CTS = 0x00000200
    set $LDB = 0x00000100
    set $TXE = 0x00000080 
    set $TC  = 0x00000040 
    set $RXNE= 0x00000020 
    set $IDLE= 0x00000010 
    set $ORE = 0x00000008 
    set $NF  = 0x00000004 
    set $FE  = 0x00000002 
    set $PE  = 0x00000001 

#USART1
    set $usart_sr = $USART1_SR
    p/x $usart_sr
    printf "Active UART1 interrupts = \n"
  
    set $mask = $CTS
    if ((*$usart_sr & $mask) == $mask)
        printf "CTS"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $LDB
    if ((*$usart_sr & $mask) == $mask)
        printf "LDB"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $TXE
    if ((*$usart_sr & $mask) == $mask)
        printf "TXE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $TC
    if ((*$usart_sr & $mask) == $mask)
        printf "TC"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $RXNE
    if ((*$usart_sr & $mask) == $mask)
        printf "RXNE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $IDLE
    if ((*$usart_sr & $mask) == $mask)
        printf "IDLE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $ORE
    if ((*$usart_sr & $mask) == $mask)
        printf "ORE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $NF
    if ((*$usart_sr & $mask) == $mask)
        printf "NF"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $FE
    if ((*$usart_sr & $mask) == $mask)
        printf "FE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $PE
    if ((*$usart_sr & $mask) == $mask)
        printf "PE"
        printf " == 1"
        printf "\n"
    end 
    printf "\n\n" 
#USART END
    
#USART2
    set $usart_sr = $USART2_SR
    p/x $usart_sr
    printf "Active UART2 interrupts = \n"
  
    set $mask = $CTS
    if ((*$usart_sr & $mask) == $mask)
        printf "CTS"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $LDB
    if ((*$usart_sr & $mask) == $mask)
        printf "LDB"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $TXE
    if ((*$usart_sr & $mask) == $mask)
        printf "TXE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $TC
    if ((*$usart_sr & $mask) == $mask)
        printf "TC"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $RXNE
    if ((*$usart_sr & $mask) == $mask)
        printf "RXNE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $IDLE
    if ((*$usart_sr & $mask) == $mask)
        printf "IDLE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $ORE
    if ((*$usart_sr & $mask) == $mask)
        printf "ORE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $NF
    if ((*$usart_sr & $mask) == $mask)
        printf "NF"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $FE
    if ((*$usart_sr & $mask) == $mask)
        printf "FE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $PE
    if ((*$usart_sr & $mask) == $mask)
        printf "PE"
        printf " == 1"
        printf "\n"
    end
    printf "\n\n" 
#USART END

#USART3
    set $usart_sr = $USART3_SR
    p/x $usart_sr
    printf "Active UART3 interrupts = \n"
  
    set $mask = $CTS
    if ((*$usart_sr & $mask) == $mask)
        printf "CTS"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $LDB
    if ((*$usart_sr & $mask) == $mask)
        printf "LDB"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $TXE
    if ((*$usart_sr & $mask) == $mask)
        printf "TXE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $TC
    if ((*$usart_sr & $mask) == $mask)
        printf "TC"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $RXNE
    if ((*$usart_sr & $mask) == $mask)
        printf "RXNE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $IDLE
    if ((*$usart_sr & $mask) == $mask)
        printf "IDLE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $ORE
    if ((*$usart_sr & $mask) == $mask)
        printf "ORE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $NF
    if ((*$usart_sr & $mask) == $mask)
        printf "NF"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $FE
    if ((*$usart_sr & $mask) == $mask)
        printf "FE"
        printf " == 1"
        printf "\n"
    end 

    set $mask = $PE
    if ((*$usart_sr & $mask) == $mask)
        printf "PE"
        printf " == 1"
        printf "\n"
    end 
    printf "\n\n" 
#USART END

end

document m3_uart
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

#dma buffer
  printf "dma_buffer \n"
  printf "pointer = %u; space_left = %u;\n", dma_eeg_rx_buffer.rx_data_from_spi_pointer, dma_eeg_rx_buffer.space_left
  set $point_to = dma_eeg_rx_buffer.rx_data_from_spi_pointer

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
      printf "                \\/\\/\\/\\/   \n"
    end
    p/x dma_eeg_rx_buffer.dma_spi_rx_data_B[$i].eeg_data_structure.info
    set $i = $i+1
  end

printf "\n"
printf "\n"
printf "\n"
printf "\n"

#dma buffer OLD  
  printf "<< OLD >> dma_buffer << OLD >>\n"
  printf "pointer = %u; space_left = %u;\n", eeg_dma_buffer_old_cpy.rx_data_from_spi_pointer, eeg_dma_buffer_old_cpy.space_left
  set $point_to = eeg_dma_buffer_old_cpy.rx_data_from_spi_pointer

  set $i = 0
  set $size = 5
  while $i < $size
    if ($i == $point_to)
      printf "                \\/\\/\\/\\/   \n"
    end
    p/x eeg_dma_buffer_old_cpy.dma_spi_rx_data_A[$i].eeg_data_structure.info
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
    p/x eeg_dma_buffer_old_cpy.dma_spi_rx_data_B[$i].eeg_data_structure.info
    set $i = $i+1
  end

printf "  --  \n"
  printf "eeg_buffer_pre_data_A_old \n"
  p/x eeg_buffer_pre_data_A_old
  printf "dma_eeg_rx_buffer.copy_in_process \n"
  p dma_eeg_rx_buffer.copy_in_process
  printf "no_space_left_dma_buff_eeg \n"
  p no_space_left_dma_buff_eeg
  
end

document m3_ehealth_buf_plot
STM32l100rc ehealth project
Shows buffer status
This function is usefull to see whole situation
end


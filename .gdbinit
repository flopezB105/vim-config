# File name:    .gdbinit
# Description:   Gdb new commands for diferent pourposes
# Version:       1.0
# Created:       2015_09_01__09:17:54
# Revision:      none
# 
# Author:        flopez 

#CONFIG
set history save on
set breakpoint pending on

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

#ENABLE HARD FAULT OP
define m3_hard_enable
  set $SCB_CCR     = ($SCB_BASE + 0x14)
  set $SCB_SHP_BASE= ($SCB_BASE + 0x18)
  set $SCB_SHCSR   = ($SCB_BASE + 0x24)

  set *$SCB_SHCSR = (*$SCB_SHCSR | 0x00070000)

  printf "enable usage-, bus-, and MMu Fault\n"
end

define m3_hard_all_enable
  set $SCB_CCR     = ($SCB_BASE + 0x14)
  set $SCB_SHP_BASE= ($SCB_BASE + 0x18)
  set $SCB_SHCSR   = ($SCB_BASE + 0x24)

  set *$SCB_SHCSR = (*$SCB_SHCSR | 0x00070000)
  printf "enable usage-, bus-, and MMu Fault\n"
  
  set *$SCB_CCR= (*$SCB_CCR | 0x00000018)
  printf "div 0 && unaligned address enabled \n"
end

#READ HARD FAULT OPTIONS
define m3_hard
  set $ICSR = 0xE000ED04 
  set $VECTACTIVE  = 0x000001FF
  set $VECTPENDING = 0x0003F000
  set $SCB_BASE    = (0xE000E000 + 0x0D00)
  set $SCB_CCR     = ($SCB_BASE + 0x14)
  set $SCB_SHP_BASE= ($SCB_BASE + 0x18)
  set $SCB_SHCSR   = ($SCB_BASE + 0x24)
  set $SCB_CFSR    = ($SCB_BASE + 0x28)
  set $SCB_HFSR    = ($SCB_BASE + 0x2c)
  set $SCB_MMFAR   = ($SCB_BASE + 0x34)
  set $SCB_BFAR    = ($SCB_BASE + 0x38)
  
  
  printf "SCB->CCR (0x%X) = 0x%X\n", $SCB_CCR, *$SCB_CCR
  set $mask=0x00000001
  if ((*$SCB_CCR & $mask) == $mask)
     printf "NONBASETHRDENA\n"
  end
  set $mask=0x00000002
  if ((*$SCB_CCR & $mask) == $mask)
     printf "USERSETMPEND\n"
  end
  set $mask=0x00000008
  if ((*$SCB_CCR & $mask) == $mask)
     printf "UNALING_TRP\n"
  end
  set $mask=0x00000010
  if ((*$SCB_CCR & $mask) == $mask)
     printf "DIV_O_TRIP\n"
  end
  set $mask=0x00000100
  if ((*$SCB_CCR & $mask) == $mask)
     printf "BFHFNMIGN\n"
  end
  set $mask=0x00000200
  if ((*$SCB_CCR & $mask) == $mask)
     printf "STKALIGN\n"
  end
  
  printf "SCB->SHCSR(0x%X) = 0x%x\n", $SCB_SHCSR, *$SCB_SHCSR
  set $mask=0x00000001
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "MEMFAULT_ACT\n"
  end
  set $mask=0x00000002
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "BUSFAULT_ACT\n"
  end
  set $mask=0x00000008
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "USAGEFAULT_ACT\n"
  end
  set $mask=0x00000080
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "SVCALLACT\n"
  end
  set $mask=0x00000100
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "MONITORACT\n"
  end
  set $mask=0x00000400
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "PENDSVACT\n"
  end
  set $mask=0x00000800
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "SYSTICKACT\n"
  end
  set $mask=0x00001000
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "USGFAULTPENDED\n"
  end
  set $mask=0x00002000
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "MEMFAULTPEND\n"
  end
  set $mask=0x00004000
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "BUSFAULTPEND\n"
  end
  set $mask=0x00008000
  if ((*$SCB_SHCSR & $mask) == $mask)
     printf "SVCALLPEND\n"
  end

  printf "SCB->CFSR(0x%X) = 0x%X\n", $SCB_CFSR, *$SCB_CFSR
  set $mask=0x00000001
  if ((*$SCB_CFSR & $mask) == $mask)
     printf "Instruction access violation flag\n"
  end
  set $mask=0x00000002
  if ((*$SCB_CFSR & $mask) == $mask)
     printf "Data access violation flag\n"
  end
  set $mask=0x00000008
  if ((*$SCB_CFSR & $mask) == $mask)
     printf "unstacking for an exception return has caused one or more access violations.  This fault is chained to the handler which means that the original return stack is still present. The processor has not adjusted the SP from the failing return, and has not performed a new save. The processor has not written a fault address to the SCB->MMFAR. Potential reasons: a) Stack pointer is corrupted b) MPU region for the stack changed during execution of the exception handler\n"
  end
  set $mask=0x00000010
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " stacking for an exception entry has caused one or more access violations.  The SP is still adjusted but the values in the context area on the stack might be incorrect.  The processor has not written a fault address to the SCB->MMFAR. Potential reasons: a) Stack pointer is corrupted or not initialized b) Stack is reaching a region not defined by the MPU as read/write memory \n"
  end
  set $mask=0x00000020
  if ((*$SCB_CFSR & $mask) == $mask)
     printf "MLSPERR\n"
  end
  set $mask=0x00000080
  if ((*$SCB_CFSR & $mask) == $mask)
     printf "Memory Management Fault Address Register (SCB->MMFAR) valid flag: 0 = value in SCB->MMFAR is not a valid fault address 1 = SCB->MMFAR holds a valid fault address.  If a Memory Management Fault occurs and is escalated to a Hard Fault because of priority, the Hard Fault handler must set this bit to 0. This prevents problems on return to a stacked active Memory Management Fault handler whose SCB->MMFAR value has been overwritten.  \n"
  end
  set $mask=0x00000100
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " Instruction bus error\n"
  end
  set $mask=0x00000200
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " Precise data bus error\n"
  end
  set $mask=0x00000400
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " Imprecise data bus error\n"
  end
  set $mask=0x00000800
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " BusFault on unstacking for a return from exception\n"
  end
  set $mask=0x00001000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " BusFault on stacking for exception entry\n"
  end
  set $mask=0x00002000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " LSPERR\n"
  end
  set $mask=0x00008000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf "Bus Fault Address Register (SCB->BFAR) valid flag: 0 = value in BFAR is not a valid fault address 1 = BFAR holds a valid fault address. The processor sets this bit after a Bus Fault where the address is known. Other faults can set this bit to 0, such as a Memory Management Fault occurring later. If a Bus Fault occurs and is escalated to a Hard Fault because of priority, the Hard Fault handler must set this bit to 0. This prevents problems if returning to a stacked active Bus Fault handler whose SCB->BFAR value has been overwritten \n"
  end
  set $mask=0x00010000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " UNDEFINSTR\n"
  end
  set $mask=0x00020000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " INVSTATE\n"
  end
  set $mask=0x00040000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " INVPC\n"
  end
  set $mask=0x00080000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " NOCP\n"
  end
  set $mask=0x01000000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " UNALIGNED\n"
  end
  set $mask=0x02000000
  if ((*$SCB_CFSR & $mask) == $mask)
     printf " DIVBYZERO\n"
  end

  printf "SCB->SHP[12] = \n"
  x/3x $SCB_SHP_BASE

  printf "SCB->HFSR = 0x%X\n"  , *$SCB_HFSR 
  printf "SCB->MMFAR = 0x%X\n" , *$SCB_MMFAR 
  printf "SCB->BFAR = 0x%X\n"  , *$SCB_BFAR   
  

end

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
  set $it_id = 26 
  if ($active_it == $it_id)
    printf "TIM10"
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




#CURRENT && NEXT INTERRUPT
define m0_it
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
  set $it_id = 2 
  if ($active_it == $it_id)
    printf "RTC"
    printf "\n"
  end 
  set $it_id = 3 
  if ($active_it == $it_id)
    printf "FLASH"
    printf "\n"
  end 
  set $it_id = 4 
  if ($active_it == $it_id)
    printf "RCC"
    printf "\n"
  end 
  set $it_id = 5 
  if ($active_it == $it_id)
    printf "EXTI0_1"
    printf "\n"
  end 
  set $it_id = 6 
  if ($active_it == $it_id)
    printf "EXTI2_3"
    printf "\n"
  end 
  set $it_id = 7 
  if ($active_it == $it_id)
    printf "EXTI4_15"
    printf "\n"
  end 
  set $it_id = 9 
  if ($active_it == $it_id)
    printf "DMA1_Channel1"
    printf "\n"
  end 
  set $it_id = 10 
  if ($active_it == $it_id)
    printf "DMA1_Channel2_3"
    printf "\n"
  end 
  set $it_id = 11 
  if ($active_it == $it_id)
    printf "DMA1_Channel4_5"
    printf "\n"
  end 
  set $it_id = 12 
  if ($active_it == $it_id)
    printf "ADC"
    printf "\n"
  end 
  set $it_id = 13 
  if ($active_it == $it_id)
    printf "TIM1_BRK_UP_TRG_COM"
    printf "\n"
  end 
  set $it_id = 14 
  if ($active_it == $it_id)
    printf "TIM1_CC"
    printf "\n"
  end 
  set $it_id = 16 
  if ($active_it == $it_id)
    printf "TIM3"
    printf "\n"
  end 
  set $it_id = 17 
  if ($active_it == $it_id)
    printf "TIM6"
    printf "\n"
  end 
  set $it_id = 19  
  if ($active_it == $it_id)
    printf "TIM14" 
    printf "\n"
  end
  set $it_id = 20  
  if ($active_it == $it_id)
    printf "TIM15"
    printf "\n"
  end
  set $it_id = 21  
  if ($active_it == $it_id)
    printf "TIM16"
    printf "\n"
  end
  set $it_id = 22  
  if ($active_it == $it_id)
    printf "TIM17"
    printf "\n"
  end
  set $it_id = 23  
  if ($active_it == $it_id)
    printf "I2C1"
    printf "\n"
  end
  set $it_id = 24  
  if ($active_it == $it_id)
    printf "I2C2"
    printf "\n"
  end
  set $it_id = 25  
  if ($active_it == $it_id)
    printf "SPI1"
    printf "\n"
  end
  set $it_id = 26  
  if ($active_it == $it_id)
    printf "SPI2"
    printf "\n"
  end
  set $it_id = 27  
  if ($active_it == $it_id)
    printf "USART1"
    printf "\n"
  set $it_id = 28  
  if ($active_it == $it_id)
    printf "USART2"
    printf "\n"
  set $it_id = 29  
  if ($active_it == $it_id)
    printf "USART3_4_5_6"
    printf "\n"
  end
  set $it_id = 31  
  if ($active_it == $it_id)
    printf "USB"
    printf "\n"
  end

end

document m0_it
end

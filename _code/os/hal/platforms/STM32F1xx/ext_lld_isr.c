/*
    ChibiOS/RT - Copyright (C) 2006-2013 Giovanni Di Sirio

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

/**
 * @file    STM32F1xx/ext_lld_isr.c
 * @brief   STM32F1xx EXT subsystem low level driver ISR code.
 *
 * @addtogroup EXT
 * @{
 */

#include "ch.h"
#include "hal.h"

#if HAL_USE_EXT || defined(__DOXYGEN__)

#include "ext_lld_isr.h"

/*===========================================================================*/
/* Driver local definitions.                                                 */
/*===========================================================================*/

/*===========================================================================*/
/* Driver exported variables.                                                */
/*===========================================================================*/

/*===========================================================================*/
/* Driver local variables.                                                   */
/*===========================================================================*/

/*===========================================================================*/
/* Driver local functions.                                                   */
/*===========================================================================*/

/*===========================================================================*/
/* Driver interrupt handlers.                                                */
/*===========================================================================*/

/**
 * @brief   EXTI[0] interrupt handler.
 *
 * @isr
 */
CH_IRQ_HANDLER(EXTI0_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 0);
  EXTD1.config->channels[0].cb(&EXTD1, 0);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[1] interrupt handler.
 *
 * @isr
 */
CH_IRQ_HANDLER(EXTI1_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 1);
  EXTD1.config->channels[1].cb(&EXTD1, 1);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[2] interrupt handler.
 *
 * @isr
 */
CH_IRQ_HANDLER(EXTI2_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 2);
  EXTD1.config->channels[2].cb(&EXTD1, 2);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[3] interrupt handler.
 *
 * @isr
 */
CH_IRQ_HANDLER(EXTI3_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 3);
  EXTD1.config->channels[3].cb(&EXTD1, 3);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[4] interrupt handler.
 *
 * @isr
 */
CH_IRQ_HANDLER(EXTI4_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 4);
  EXTD1.config->channels[4].cb(&EXTD1, 4);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[5]...EXTI[9] interrupt handler.
 *
 * @isr
 */
CH_IRQ_HANDLER(EXTI9_5_IRQHandler) {
  uint32_t pr;

  CH_IRQ_PROLOGUE();

  pr = EXTI->PR & ((1U << 5) | (1U << 6) | (1U << 7) | (1U << 8) | (1U << 9));
  EXTI->PR = pr;
  if (pr & (1U << 5))
    EXTD1.config->channels[5].cb(&EXTD1, 5);
  if (pr & (1U << 6))
    EXTD1.config->channels[6].cb(&EXTD1, 6);
  if (pr & (1U << 7))
    EXTD1.config->channels[7].cb(&EXTD1, 7);
  if (pr & (1U << 8))
    EXTD1.config->channels[8].cb(&EXTD1, 8);
  if (pr & (1U << 9))
    EXTD1.config->channels[9].cb(&EXTD1, 9);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[10]...EXTI[15] interrupt handler.
 *
 * @isr
 */
CH_IRQ_HANDLER(EXTI15_10_IRQHandler) {
  uint32_t pr;

  CH_IRQ_PROLOGUE();

  pr = EXTI->PR & ((1U << 10) | (1U << 11) | (1U << 12) | (1U << 13) | (1U << 14) |
                   (1U << 15));
  EXTI->PR = pr;
  if (pr & (1U << 10))
    EXTD1.config->channels[10].cb(&EXTD1, 10);
  if (pr & (1U << 11))
    EXTD1.config->channels[11].cb(&EXTD1, 11);
  if (pr & (1U << 12))
    EXTD1.config->channels[12].cb(&EXTD1, 12);
  if (pr & (1U << 13))
    EXTD1.config->channels[13].cb(&EXTD1, 13);
  if (pr & (1U << 14))
    EXTD1.config->channels[14].cb(&EXTD1, 14);
  if (pr & (1U << 15))
    EXTD1.config->channels[15].cb(&EXTD1, 15);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[16] interrupt handler (PVD).
 *
 * @isr
 */
CH_IRQ_HANDLER(PVD_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 16);
  EXTD1.config->channels[16].cb(&EXTD1, 16);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[17] interrupt handler (RTC).
 *
 * @isr
 */
CH_IRQ_HANDLER(RTC_Alarm_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 17);
  EXTD1.config->channels[17].cb(&EXTD1, 17);

  CH_IRQ_EPILOGUE();
}

#if defined(STM32F10X_CL)
/**
 * @brief   EXTI[18] interrupt handler (OTG_FS_WKUP).
 *
 * @isr
 */
CH_IRQ_HANDLER(OTG_FS_WKUP_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 18);
  EXTD1.config->channels[18].cb(&EXTD1, 18);

  CH_IRQ_EPILOGUE();
}

/**
 * @brief   EXTI[19] interrupt handler (ETH_WKUP).
 *
 * @isr
 */
CH_IRQ_HANDLER(ETH_WKUP_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 19);
  EXTD1.config->channels[19].cb(&EXTD1, 19);

  CH_IRQ_EPILOGUE();
}
#elif defined(STM32F10X_LD_VL) || defined(STM32F10X_MD_VL) ||               \
      defined(STM32F10X_HD_VL)

#else /* Other STM32F1xx devices.*/
/**
 * @brief   EXTI[18] interrupt handler (USB_FS_WKUP).
 *
 * @isr
 */
CH_IRQ_HANDLER(USB_FS_WKUP_IRQHandler) {

  CH_IRQ_PROLOGUE();

  EXTI->PR = (1U << 18);
  EXTD1.config->channels[18].cb(&EXTD1, 18);

  CH_IRQ_EPILOGUE();
}
#endif

/*===========================================================================*/
/* Driver exported functions.                                                */
/*===========================================================================*/

/**
 * @brief   Enables EXTI IRQ sources.
 *
 * @notapi
 */
void ext_lld_exti_irq_enable(void) {

  nvicEnableVector(EXTI0_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI0_IRQ_PRIORITY));
  nvicEnableVector(EXTI1_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI1_IRQ_PRIORITY));
  nvicEnableVector(EXTI2_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI2_IRQ_PRIORITY));
  nvicEnableVector(EXTI3_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI3_IRQ_PRIORITY));
  nvicEnableVector(EXTI4_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI4_IRQ_PRIORITY));
  nvicEnableVector(EXTI9_5_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI5_9_IRQ_PRIORITY));
  nvicEnableVector(EXTI15_10_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI10_15_IRQ_PRIORITY));
  nvicEnableVector(PVD_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI16_IRQ_PRIORITY));
  nvicEnableVector(RTC_Alarm_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI17_IRQ_PRIORITY));
#if defined(STM32F10X_CL)
  /* EXTI vectors specific to STM32F1xx Connectivity Line.*/
  nvicEnableVector(OTG_FS_WKUP_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI18_IRQ_PRIORITY));
  nvicEnableVector(ETH_WKUP_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI19_IRQ_PRIORITY));
#elif defined(STM32F10X_LD_VL) || defined(STM32F10X_MD_VL) ||               \
      defined(STM32F10X_HD_VL)
  /* EXTI vectors specific to STM32F1xx Value Line.*/
#else
  /* EXTI vectors specific to STM32F1xx except Connectivity Line.*/
  nvicEnableVector(USB_FS_WKUP_IRQn,
                   CORTEX_PRIORITY_MASK(STM32_EXT_EXTI18_IRQ_PRIORITY));
#endif
}

/**
 * @brief   Disables EXTI IRQ sources.
 *
 * @notapi
 */
void ext_lld_exti_irq_disable(void) {

  nvicDisableVector(EXTI0_IRQn);
  nvicDisableVector(EXTI1_IRQn);
  nvicDisableVector(EXTI2_IRQn);
  nvicDisableVector(EXTI3_IRQn);
  nvicDisableVector(EXTI4_IRQn);
  nvicDisableVector(EXTI9_5_IRQn);
  nvicDisableVector(EXTI15_10_IRQn);
  nvicDisableVector(PVD_IRQn);
  nvicDisableVector(RTC_Alarm_IRQn);
#if defined(STM32F10X_CL)
  /* EXTI vectors specific to STM32F1xx Connectivity Line.*/
  nvicDisableVector(OTG_FS_WKUP_IRQn);
  nvicDisableVector(ETH_WKUP_IRQn);
#elif defined(STM32F10X_LD_VL) || defined(STM32F10X_MD_VL) ||               \
    defined(STM32F10X_HD_VL)
  /* EXTI vectors specific to STM32F1xx Value Line.*/
#else
  /* EXTI vectors specific to STM32F1xx except Connectivity Line.*/
  nvicDisableVector(USB_FS_WKUP_IRQn);
#endif
}

#endif /* HAL_USE_EXT */

/** @} */

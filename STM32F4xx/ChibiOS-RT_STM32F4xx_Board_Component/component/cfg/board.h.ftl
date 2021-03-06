[#ftl]
[@pp.dropOutputFile /]
[@pp.changeOutputFile name="board.h" /]
[#assign bits = ["0", "1", "2", "3", "4", "5", "6", "7",
                 "8", "9", "10", "11", "12", "13", "14", "15"] /]
[#assign ports = ["GPIOA", "GPIOB", "GPIOC", "GPIOD", "GPIOE",
                  "GPIOF", "GPIOG", "GPIOH", "GPIOI"] /]
/*
    ChibiOS/RT - Copyright (C) 2006,2007,2008,2009,2010,
                 2011,2012 Giovanni Di Sirio.

    This file is part of ChibiOS/RT.

    ChibiOS/RT is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    ChibiOS/RT is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

                                      ---

    A special exception to the GPL can be applied should you wish to distribute
    a combined work that includes ChibiOS/RT, without being obliged to provide
    the source code for any proprietary components. See the file exception.txt
    for full details of how and when the exception can be applied.
*/

#ifndef _BOARD_H_
#define _BOARD_H_

/*
 * Setup for a generic STM32F4xx board.
 */

/*
 * Board identifier.
 */
#define BOARD_${conf.instance.identification.board_identifier.value[0]}
#define BOARD_NAME                  "${conf.instance.identification.board_name.value[0]}"

[#if conf.instance.phy_settings.address.value[0]?string?trim?lower_case != "none"]
/*
 * Ethernet PHY type.
 */
#define BOARD_PHY_ID                ${conf.instance.phy_settings.id.value[0]}
[#if conf.instance.phy_settings.mode.value[0]?string?trim?lower_case == "rmii"]
#define BOARD_PHY_RMII
[/#if]
[#if conf.instance.phy_settings.address.value[0]?string?trim?lower_case != "autoscan"]
#define BOARD_PHY_ADDRESS           ${conf.instance.phy_settings.address.value[0]}
[/#if]

[/#if]
/*
 * Board oscillators-related settings.
 */
[#if conf.instance.clock_settings.lse_oscillator_mode.value[0]?string?trim?lower_case != "none"]
#define STM32_LSECLK                ${conf.instance.clock_settings.lse_frequency.value[0]}
[#if conf.instance.clock_settings.lse_oscillator_mode.value[0]?string?trim?lower_case == "bypass"]
#define STM32_LSECLK_BYPASS
[/#if]
[#else]
#define STM32_LSECLK                0
[/#if]
[#if conf.instance.clock_settings.hse_oscillator_mode.value[0]?string?trim?lower_case != "none"]
#define STM32_HSECLK                ${conf.instance.clock_settings.hse_frequency.value[0]}
[#if conf.instance.clock_settings.hse_oscillator_mode.value[0]?string?trim?lower_case == "bypass"]
#define STM32_HSECLK_BYPASS
[/#if]
[#else]
#define STM32_HSECLK                0
[/#if]

/*
 * Board voltages.
 * Required for performance limits calculation.
 */
#define STM32_VDD                   ${conf.instance.clock_settings.vdd.value[0]}

/*
 * MCU type as defined in the ST header file stm32f4xx.h.
 */
#define STM32F4XX

[#-- Creating an hash with all the defined pins and performing checks.--]
[#assign pins = {} /]
[#assign identifiers = {}]
[#list conf.instance.i_o_settings.pins_list.pin_settings as pin_settings]
  [#assign pin_port         = pin_settings.pin_identification.port.value[0] /]
  [#assign pin_bit          = pin_settings.pin_identification.bit.value[0]?number /]
  [#assign pin_ids          = pin_settings.pin_identification.identifiers.value[0] /]
  [#if pin_ids == ""]
    [#assign pin_ids = "PIN" + pin_bit /]
  [/#if]
  [#assign pin_mode         = pin_settings.settings.pin_mode.value[0] /]
  [#assign pin_level        = pin_settings.settings.latched_state[0].@index?number /]
  [#assign pin_type         = pin_settings.settings.output_type.value[0] /]
  [#assign pin_speed        = pin_settings.settings.output_speed.value[0] /]
  [#assign pin_resistor     = pin_settings.settings.input_resistor.value[0] /]
  [#assign pin_mode_idx     = pin_settings.settings.pin_mode[0].@index?number /]
  [#assign pin_state_idx    = pin_settings.settings.latched_state[0].@index?number /]
  [#assign pin_type_idx     = pin_settings.settings.output_type[0].@index?number /]
  [#assign pin_speed_idx    = pin_settings.settings.output_speed[0].@index?number /]
  [#assign pin_resistor_idx = pin_settings.settings.input_resistor[0].@index?number /]
  [#assign pin_alternate    = pin_settings.settings.alternate_function[0].@index?number /]
  [#-- Adding to the identifiers hash in order to check for duplications.--]
  [#list pin_ids?word_list as id]
    [#assign id = pin_port + "_" + id /]
    [#if identifiers[id]??]
      [#stop "Multiple definitions of " + id /]
    [#else]
      [#assign identifiers = identifiers + {id:""} /]
    [/#if]
  [/#list]
  [#-- Adding to the pins hash for later use.--]
  [#assign key = pin_port + "-" + pin_bit /]
  [#if pins[key]?? ]
    [#stop "Multiple definitions of " + key /]
  [#else]
    [#assign value = {"port":pin_port, "bit":pin_bit, "ids":pin_ids,
                      "mode":pin_mode,         "mode_idx":pin_mode_idx,
                      "type":pin_type,         "type_idx":pin_type_idx,
                      "speed":pin_speed,       "speed_idx":pin_speed_idx,
                      "resistor":pin_resistor, "resistor_idx":pin_resistor_idx,
                      "level":pin_level,       "alternate":pin_alternate} /]
    [#assign pins = pins + {key:value} /]
  [/#if]
[/#list]
/*
 * IO pins assignments.
 */
[#list ports as port]
  [#list bits as bit]
    [#assign key = port + "-" + bit /]
    [#if pins[key]?? ]
      [#assign pin = pins[key] /]
      [#assign ids = pin["ids"] /]
    [#else]
      [#-- The pin has not been defined explicitly, adding to the hash
           using the default settings.--]
      [#assign ids = "PIN" + bit /]
      [#assign value = {"port":port, "bit":bit, "ids":ids,
                        "mode":"Input",         "mode_idx":0,
                        "type":"",              "type_idx":0,
                        "speed":"",             "speed_idx":0,
                        "resistor":"Pull-Up",   "resistor_idx":1,
                        "level":0,              "alternate":0} /]
      [#assign pins = pins + {key:value} /]
    [/#if]
    [#list ids?word_list as id]
#define ${port + "_"  + id?right_pad(27, " ")} ${bit}
    [/#list]
  [/#list]

[/#list]

/*
 * I/O ports initial setup, this configuration is established soon after reset
 * in the initialization code.
 * Please refer to the STM32 Reference Manual for details.
 */
#define PIN_MODE_INPUT(n)           (0U << ((n) * 2))
#define PIN_MODE_OUTPUT(n)          (1U << ((n) * 2))
#define PIN_MODE_ALTERNATE(n)       (2U << ((n) * 2))
#define PIN_MODE_ANALOG(n)          (3U << ((n) * 2))
#define PIN_ODR_LOW(n)              (0U << (n))
#define PIN_ODR_HIGH(n)             (1U << (n))
#define PIN_OTYPE_PUSHPULL(n)       (0U << (n))
#define PIN_OTYPE_OPENDRAIN(n)      (1U << (n))
#define PIN_OSPEED_2M(n)            (0U << ((n) * 2))
#define PIN_OSPEED_25M(n)           (1U << ((n) * 2))
#define PIN_OSPEED_50M(n)           (2U << ((n) * 2))
#define PIN_OSPEED_100M(n)          (3U << ((n) * 2))
#define PIN_PUPDR_FLOATING(n)       (0U << ((n) * 2))
#define PIN_PUPDR_PULLUP(n)         (1U << ((n) * 2))
#define PIN_PUPDR_PULLDOWN(n)       (2U << ((n) * 2))
#define PIN_AFIO_AF(n, v)           ((v##U) << ((n % 8) * 4))

[#--
  -- Generating pin descriptions inside the comment.
  --]
[#list ports as port]
/*
 * ${port} setup:
 *
  [#list bits as bit]
    [#assign pin = pins[port + "-" + bit] /]
    [#assign mode = pin["mode_idx"] /]
    [#if mode == 0]
      [#assign desc = "Input " + pin["resistor"] /]
    [#elseif mode == 1]
      [#assign desc = "Output " + pin["type"] + " " + pin["speed"] /]
    [#elseif mode == 2]
      [#assign desc = "Alternate " + pin["alternate"] /]
    [#else]
      [#assign desc = "Analog" /]
    [/#if]
 * P${(port[4..] + bit?string)?right_pad(3, " ")} - ${pin["ids"][0]?right_pad(26, " ")}(${desc?lower_case}).
  [/#list]
 */
  [#--
    -- Generating MODER register value.
    --]
  [#list bits as bit]
    [#assign pin = pins[port + "-" + bit] /]
    [#assign name = port + "_" + pin["ids"]?word_list[0] /]
    [#assign mode = pin["mode_idx"] /]
    [#if mode == 0]
      [#assign out = "PIN_MODE_INPUT(" + name + ")" /]
    [#elseif mode == 1]
      [#assign out = "PIN_MODE_OUTPUT(" + name + ")" /]
    [#elseif mode == 2]
      [#assign out = "PIN_MODE_ALTERNATE(" + name + ")" /]
    [#else]
      [#assign out = "PIN_MODE_ANALOG(" + name + ")" /]
    [/#if]
    [#if bit?number == 0]
      [#assign line = "#define VAL_" + port + "_MODER             (" + out /]
    [#else]
      [#assign line = "                                     " + out /]
    [/#if]
    [#if bit?number < 15]
${(line + " |")?right_pad(76, " ") + "\\"}
    [#else]
${line + ")"}
    [/#if]
  [/#list]
  [#--
    -- Generating OTYPER register value.
    --]
  [#list bits as bit]
    [#assign pin = pins[port + "-" + bit] /]
    [#assign name = port + "_" + pin["ids"]?word_list[0] /]
    [#assign type = pin["type_idx"] /]
    [#if type == 0]
      [#assign out = "PIN_OTYPE_PUSHPULL(" + name + ")" /]
    [#else]
      [#assign out = "PIN_OTYPE_OPENDRAIN(" + name + ")" /]
    [/#if]
    [#if bit?number == 0]
      [#assign line = "#define VAL_" + port + "_OTYPER            (" + out /]
    [#else]
      [#assign line = "                                     " + out /]
    [/#if]
    [#if bit?number < 15]
${(line + " |")?right_pad(76, " ") + "\\"}
    [#else]
${line + ")"}
    [/#if]
  [/#list]
  [#--
    -- Generating SPEEDR register value.
    --]
  [#list bits as bit]
    [#assign pin = pins[port + "-" + bit] /]
    [#assign name = port + "_" + pin["ids"]?word_list[0] /]
    [#assign speed = pin["speed_idx"] /]
    [#if speed == 0]
      [#assign out = "PIN_OSPEED_2M(" + name + ")" /]
    [#elseif speed == 1]
      [#assign out = "PIN_OSPEED_25M(" + name + ")" /]
    [#elseif speed == 2]
      [#assign out = "PIN_OSPEED_50M(" + name + ")" /]
    [#else]
      [#assign out = "PIN_OSPEED_100M(" + name + ")" /]
    [/#if]
    [#if bit?number == 0]
      [#assign line = "#define VAL_" + port + "_OSPEEDR           (" + out /]
    [#else]
      [#assign line = "                                     " + out /]
    [/#if]
    [#if bit?number < 15]
${(line + " |")?right_pad(76, " ") + "\\"}
    [#else]
${line + ")"}
    [/#if]
  [/#list]
  [#--
    -- Generating PUPDR register value.
    --]
  [#list bits as bit]
    [#assign pin = pins[port + "-" + bit] /]
    [#assign name = port + "_" + pin["ids"]?word_list[0] /]
    [#assign resistor = pin["resistor_idx"] /]
    [#if resistor == 0]
      [#assign out = "PIN_PUPDR_FLOATING(" + name + ")" /]
    [#elseif resistor == 1]
      [#assign out = "PIN_PUPDR_PULLUP(" + name + ")" /]
    [#else]
      [#assign out = "PIN_PUPDR_PULLDOWN(" + name + ")" /]
    [/#if]
    [#if bit?number == 0]
      [#assign line = "#define VAL_" + port + "_PUPDR             (" + out /]
    [#else]
      [#assign line = "                                     " + out /]
    [/#if]
    [#if bit?number < 15]
${(line + " |")?right_pad(76, " ") + "\\"}
    [#else]
${line + ")"}
    [/#if]
  [/#list]
  [#--
    -- Generating ODR register value.
    --]
  [#list bits as bit]
    [#assign pin = pins[port + "-" + bit] /]
    [#assign name = port + "_" + pin["ids"]?word_list[0] /]
    [#assign level = pin["level"] /]
    [#if level == 0]
      [#assign out = "PIN_ODR_LOW(" + name + ")" /]
    [#else]
      [#assign out = "PIN_ODR_HIGH(" + name + ")" /]
    [/#if]
    [#if bit?number == 0]
      [#assign line = "#define VAL_" + port + "_ODR               (" + out /]
    [#else]
      [#assign line = "                                     " + out /]
    [/#if]
    [#if bit?number < 15]
${(line + " |")?right_pad(76, " ") + "\\"}
    [#else]
${line + ")"}
    [/#if]
  [/#list]
  [#--
    -- Generating AFRx registers values.
    --]
  [#list bits as bit]
    [#assign pin = pins[port + "-" + bit] /]
    [#assign name = port + "_" + pin["ids"]?word_list[0] /]
    [#assign alternate = pin["alternate"] /]
    [#assign out = "PIN_AFIO_AF(" + name + ", " + alternate + ")" /]
    [#if bit?number == 0]
      [#assign line = "#define VAL_" + port + "_AFRL              (" + out /]
    [#elseif bit?number == 8]
      [#assign line = "#define VAL_" + port + "_AFRH              (" + out /]
    [#else]
      [#assign line = "                                     " + out /]
    [/#if]
    [#if (bit?number == 7) || (bit?number == 15)]
${line + ")"}
    [#else]
${(line + " |")?right_pad(76, " ") + "\\"}
    [/#if]
  [/#list]

[/#list]

#if !defined(_FROM_ASM_)
#ifdef __cplusplus
extern "C" {
#endif
  void boardInit(void);
#ifdef __cplusplus
}
#endif
#endif /* _FROM_ASM_ */

#endif /* _BOARD_H_ */

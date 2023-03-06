# THIS FILE IS AUTOMATICALLY GENERATED. DO NOT EDIT.
# BASED ON c:\source\ewprep\GTZC_TZSC_MPCBB_TrustZone-Nucleo-L55\NonSecure

function(add_st_target_properties TARGET_NAME)

execute_process(
    COMMAND ${CMAKE_COMMAND} --preset ${PRESET_NAME}
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/..\\Secure"
)

add_custom_target(
    "GTZC_TZSC_MPCBB_TrustZone_Secure"
    COMMAND ${CMAKE_COMMAND} --build --preset ${PRESET_NAME}
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/..\\Secure"
)

add_dependencies(${TARGET_NAME} "GTZC_TZSC_MPCBB_TrustZone_Secure")

target_compile_definitions(
    ${TARGET_NAME} PRIVATE
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:ASM>>:DEBUG>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:DEBUG>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:USE_HAL_DRIVER>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:STM32L552xx>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:USE_HAL_DRIVER>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:STM32L552xx>"
)

target_include_directories(
    ${TARGET_NAME} PRIVATE
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/Inc>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Secure_nsclib>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Drivers\\STM32L5xx_HAL_Driver\\Inc>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Drivers\\CMSIS\\Device\\ST\\STM32L5xx\\Include>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Drivers\\STM32L5xx_HAL_Driver\\Inc\\Legacy>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Drivers\\CMSIS\\Include>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/Inc>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Secure_nsclib>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Drivers\\STM32L5xx_HAL_Driver\\Inc>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Drivers\\CMSIS\\Device\\ST\\STM32L5xx\\Include>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Drivers\\STM32L5xx_HAL_Driver\\Inc\\Legacy>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:${PROJECT_SOURCE_DIR}/..\\Drivers\\CMSIS\\Include>"
)

target_compile_options(
    ${TARGET_NAME} PRIVATE
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:ASM>>:-g3>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:-g3>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:CXX>>:-g3>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:ASM>>:-g0>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:-g0>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:CXX>>:-g0>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:-Os>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:CXX>>:-Os>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:>"
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:CXX>>:>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:C>>:>"
    "$<$<AND:$<NOT:$<CONFIG:Debug>>,$<COMPILE_LANGUAGE:CXX>>:>"
    "$<$<CONFIG:Debug>:-mcpu=cortex-m33>"
    "$<$<CONFIG:Debug>:-mfpu=fpv5-sp-d16>"
    "$<$<CONFIG:Debug>:-mfloat-abi=hard>"
    "$<$<NOT:$<CONFIG:Debug>>:-mcpu=cortex-m33>"
    "$<$<NOT:$<CONFIG:Debug>>:-mfpu=fpv5-sp-d16>"
    "$<$<NOT:$<CONFIG:Debug>>:-mfloat-abi=hard>"
)

target_link_libraries(
    ${TARGET_NAME} PRIVATE
)

target_link_directories(
    ${TARGET_NAME} PRIVATE
)

target_link_options(
    ${TARGET_NAME} PRIVATE
    "$<$<CONFIG:Debug>:-mcpu=cortex-m33>"
    "$<$<CONFIG:Debug>:-mfpu=fpv5-sp-d16>"
    "$<$<CONFIG:Debug>:-mfloat-abi=hard>"
    "$<$<NOT:$<CONFIG:Debug>>:-mcpu=cortex-m33>"
    "$<$<NOT:$<CONFIG:Debug>>:-mfpu=fpv5-sp-d16>"
    "$<$<NOT:$<CONFIG:Debug>>:-mfloat-abi=hard>"
    -T
    "$<$<CONFIG:Debug>:${PROJECT_SOURCE_DIR}/STM32L552ZETXQ_FLASH.ld>"
    "$<$<NOT:$<CONFIG:Debug>>:${PROJECT_SOURCE_DIR}/STM32L552ZETXQ_FLASH.ld>"
    "$<$<CONFIG:Debug>:${PROJECT_SOURCE_DIR}/..\\Secure\\build\\debug\\build\\secure_nsclib.o>"
    "$<$<NOT:$<CONFIG:Debug>>:${PROJECT_SOURCE_DIR}/..\\Secure\\build\\release\\build\\secure_nsclib.o>"
)

target_sources(
    ${TARGET_NAME} PRIVATE
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_cortex.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_dma.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_dma_ex.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_exti.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_flash.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_flash_ex.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_flash_ramfunc.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_gpio.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_i2c.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_i2c_ex.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_icache.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_pwr.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_pwr_ex.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_rcc.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_rcc_ex.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_tim.c"
    "../Drivers/STM32L5xx_HAL_Driver/Src/stm32l5xx_hal_tim_ex.c"
    "Startup\\startup_stm32l552zetxq.s"
    "Src\\main.c"
    "Src\\stm32l5xx_hal_msp.c"
    "Src\\stm32l5xx_it.c"
    "Src\\syscalls.c"
    "Src\\sysmem.c"
    "Src\\system_stm32l5xx_ns.c"
)

add_custom_command(
    TARGET ${TARGET_NAME} POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${TARGET_NAME}>
)

add_custom_command(
    TARGET ${TARGET_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex
    $<TARGET_FILE:${TARGET_NAME}> ${TARGET_NAME}.hex
)

add_custom_command(
    TARGET ${TARGET_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary
    $<TARGET_FILE:${TARGET_NAME}> ${TARGET_NAME}.bin
)

endfunction()
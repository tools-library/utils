@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION



:PROCESS_CMD
    SET "utils_folder=%~dp0"
    SET "available_utilities=7zip cecho ninja graphviz vswhere"

    SET help_arg=false
    SET pack_arg=false
    SET unpack_arg=false

    SET current_arg=%1
    IF  [%current_arg%] EQU []         SET help_arg=true
    IF  [%current_arg%] EQU [-h]       SET help_arg=true
    IF  [%current_arg%] EQU [--help]   SET help_arg=true
    IF  [%current_arg%] EQU [--pack]   SET pack_arg=true
    IF  [%current_arg%] EQU [--unpack] SET unpack_arg=true

    IF  [%help_arg%] EQU [true] (
        CALL :SHOW_HELP
    ) ELSE (
        IF  [%pack_arg%] EQU [true]  (
            CALL :PACK
        ) ELSE (
            IF  [%unpack_arg%] EQU [true]  (
                CALL :UNPACK
            ) ELSE (
                CALL :MAIN %*
                IF !ERRORLEVEL! NEQ 0 (
                    EXIT /B !ERRORLEVEL!
                )
            )
        )
    )

    REM All changes to variables within this script, will have local scope. Only
    REM variables specified in the following block can propagates to the outside
    REM world (For example, a calling script of this script).
    ENDLOCAL & (
        SET "TOOLSET_UTILS_PATH=%utils_folder%"
        SET "PATH=%PATH%"
    )
EXIT /B 0



:MAIN
    CALL :UNPACK

    REM Iterate over a list of utilities passed as arguments and run the
    REM corresponding setup script.
    :LOOP
        SET utility_name=%1
        SET "utility_setup_cmd=%utils_folder%%utility_name%\setup.cmd"
        IF EXIST "%utility_setup_cmd%" (
            CALL "%utility_setup_cmd%"
        ) ELSE (
            CALL :SHOW_ERROR "An utility with name '%utility_name%' was not found."
            SET has_error=true
        )
        SHIFT
    IF NOT [%1]==[] GOTO LOOP

    IF [%has_error%] EQU [true] (
        EXIT /B -1
    )
EXIT /B 0



:PACK
    FOR %%u IN (%available_utilities%) DO (
        SET utility_name=%%u
        SET "utility_folder=%utils_folder%!utility_name!"
        CALL "!utility_folder!\setup.cmd" --pack
    )
EXIT /B 0

:UNPACK
    FOR %%u IN (%available_utilities%) DO (
        SET utility_name=%%u
        SET "utility_folder=%utils_folder%!utility_name!"
        CALL "!utility_folder!\setup.cmd" --unpack
    )
EXIT /B 0



:SHOW_INFO
    SET "cecho_cmd=%utils_folder%\cecho\software\x32\cecho.exe"
    SET msg=%~1
    IF EXIST "%cecho_cmd%" (
        "%cecho_cmd%" {olive}[TOOLSET - UTILS]{default} INFO: %msg%{\n}
    ) ELSE (
        ECHO [TOOLSET - UTILS] INFO: %msg%
    )
EXIT /B 0

:SHOW_ERROR
    SET "cecho_cmd=%utils_folder%\cecho\software\x32\cecho.exe"
    SET msg=%~1
    IF EXIST "%cecho_cmd%" (
        "%cecho_cmd%" {olive}[TOOLSET - UTILS]{red} ERROR: %msg% {default} {\n}
    ) ELSE (
        ECHO [TOOLSET - UTILS] ERROR: %msg%
    )
EXIT /B 0



:SHOW_HELP
    SET "script_name=%~n0%~x0"
    ECHO #######################################################################
    ECHO #                                                                     #
    ECHO #                      T O O L   S E T U P                            #
    ECHO #                                                                     #
    ECHO #       'UTILS' is a small collection of scripts and programs         #
    ECHO #        that can be useful in a lot of projects.                     #
    ECHO #                                                                     #
    ECHO # TOOL   : UTILS                                                      #
    ECHO # VERSION: 1.0.0                                                      #
    ECHO # ARCH   : Mixed x64 and x32.                                         #
    ECHO #                                                                     #
    ECHO # USAGE:                                                              #
    ECHO #     %script_name% {[-h^|--help^|--pack^|--unpack] ^| [utilityN...]}         #
    ECHO #                                                                     #
    ECHO # EXAMPLES:                                                           #
    ECHO #     %script_name%                                                       #
    ECHO #     %script_name% -h                                                    #
    ECHO #     %script_name% --pack                                                #
    ECHO #     %script_name% cecho ninja                                           #
    ECHO #                                                                     #
    ECHO # ARGUMENTS:                                                          #
    ECHO #     -h^|--help    Print this help and exit.                          #
    ECHO #                                                                     #
    ECHO #     --pack    Pack the content of the software folder in one        #
    ECHO #         self-extract executable called 'software.exe'.              #
    ECHO #                                                                     #
    ECHO #     --unpack    Unpack the self-extract executable 'software.exe'   #
    ECHO #         to the software folder.                                     #
    ECHO #                                                                     #
    ECHO #     utilityN    A list of utilities to setup, separated by space.   #
    ECHO #                                                                     #
    ECHO # AVAILABLE UTILITIES:                                                #
    ECHO #     cecho    Enhanced echo command line utility with color support. #
    ECHO #                                                                     #
    ECHO #     7zip    A file archiver with a high compression ratio.          #
    ECHO #                                                                     #
    ECHO #     ninja    A small build system with a focus on speed.            #
    ECHO #                                                                     #
    ECHO #     graphviz    Tools for drawing graphs in DOT language scripts.   #
    ECHO #                                                                     #
    ECHO #     vswhere    A utility to find where Visual Studio - or other     #
    ECHO #         products in the Visual Studio family - is located.          #
    ECHO #                                                                     #
    ECHO # EXPORTED ENVIRONMENT VARIABLES:                                     #
    ECHO #     TOOLSET_UTILS_PATH    Absolute path where this tool is located. #
    ECHO #                                                                     #
    ECHO #     PATH    This tool will export all local changes that it made to #
    ECHO #         the path's environment variable.                            #
    ECHO #                                                                     #
    ECHO #     The environment variables will be exported only if this tool    #
    ECHO #     executes without any error.                                     #
    ECHO #                                                                     #
    ECHO # RETURN ERROR CODES:                                                 #
    ECHO #     -1    If at least one utility was not found.                    #
    ECHO #                                                                     #
    ECHO #######################################################################
EXIT /B 0
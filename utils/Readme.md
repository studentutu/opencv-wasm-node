# Options for opecv js build

## opencv js python general options

usage: build_js.py [-h] [--opencv_dir OPENCV_DIR]
                   [--emscripten_dir EMSCRIPTEN_DIR] [--build_wasm]
                   [--disable_wasm] [--disable_single_file] [--threads]
                   [--simd] [--build_test] [--build_perf] [--build_doc]
                   [--build_loader] [--clean_build_dir] [--skip_config]
                   [--config_only] [--enable_exception]
                   [--cmake_option CMAKE_OPTION] [--build_flags BUILD_FLAGS]
                   [--build_wasm_intrin_test] [--config CONFIG] [--webnn]
                   build_dir

Build OpenCV.js by Emscripten

positional arguments:
  build_dir             Building directory (and output)

optional arguments:
  -h, --help            show this help message and exit
  --opencv_dir          OPENCV_DIR
                        Opencv source directory (default is "../.." relative
                        to script location)
  --emscripten_dir      EMSCRIPTEN_DIR
                        Path to Emscripten to use for build (deprecated in
                        favor of 'emcmake' launcher)
  --build_wasm          Build OpenCV.js in WebAssembly format
  --disable_wasm        Build OpenCV.js in Asm.js format
  --disable_single_file
                        Do not merge JavaScript and WebAssembly into one
                        single file
  --threads             Build OpenCV.js with threads optimization
  --simd                Build OpenCV.js with SIMD optimization
  --build_test          Build tests
  --build_perf          Build performance tests
  --build_doc           Build tutorials
  --build_loader        Build OpenCV.js loader
  --clean_build_dir     Clean build dir
  --skip_config         Skip cmake config
  --config_only         Only do cmake config
  --enable_exception    Enable exception handling
  --cmake_option        CMAKE_OPTION
                        Append CMake options
  --build_flags         BUILD_FLAGS
                        Append Emscripten build options
  --build_wasm_intrin_test
                        Build WASM intrin tests
  --config CONFIG       Specify configuration file with own list of exported
                        into JS functions
  --webnn               Enable WebNN Backend

## opencv js python build_flags e.g. Emscripten options

Default build flags:

``` bash
-s WASM=1 -s SINGLE_FILE=1 -s USE_PTHREADS=0 -s USE_PTHREADS_PF=0 -s EXPORTED_FUNCTIONS="['_malloc', '_free']"
```

``` python
    def get_build_flags(self):
        flags = ""
        if self.options.build_wasm:
            flags += "-s WASM=1 "
        elif self.options.disable_wasm:
            flags += "-s WASM=0 "
        if not self.options.disable_single_file:
            flags += "-s SINGLE_FILE=1 "
        if self.options.threads:
            flags += "-s USE_PTHREADS=1 -s PTHREAD_POOL_SIZE=4 "
        else:
            flags += "-s USE_PTHREADS=0 "
        if self.options.enable_exception:
            flags += "-s DISABLE_EXCEPTION_CATCHING=0 "
        if self.options.simd:
            flags += "-msimd128 "
        if self.options.build_flags:
            flags += self.options.build_flags
        if self.options.webnn:
            flags += "-s USE_WEBNN=1 "
        flags += "-s EXPORTED_FUNCTIONS=\"['_malloc', '_free']\""
        return flags
```

  --WASM = 0 | 1                Build OpenCV.js in WebAssembly format
  --SINGLE_FILE = 0 | 1         Do not merge JavaScript and WebAssembly into one
                                single file
  --USE_PTHREADS = 0 | 1        Build OpenCV.js with threads optimization
  --SIMD = 0 | 1                Build OpenCV.js with SIMD optimization
  --BUILD_TEST = 0 | 1          Build tests
  --BUILD_PERF = 0 | 1          Build performance tests
  --BUILD_DOC = 0 | 1           Build tutorials
  --BUILD_LOADER = 0 | 1        Build OpenCV.js loader
  --CLEAN_BUILD_DIR = 0 | 1     Clean build dir
  --SKIP_CONFIG = 0 | 1         Skip cmake config
  --CONFIG_ONLY = 0 | 1         Only do cmake config
  --ENABLE_EXCEPTION = 0 | 1    Enable exception handling
  -lembind                      Links against embind library ( if you need typescript definitions, use --emit-tsd but it requires Node to be installed )
  --emit-tsd                    Generates TypeScript definition file ( requires -lembind  and Node to be installed )
  --[00|01|02|03]               Enables optimizations [ -00, -01, -02, -03 ]

## Emcripten options

Emscripten Compiler Frontend (emcc)
***********************************

The Emscripten Compiler Frontend ("emcc") is used to call the
Emscripten compiler from the command line. It is effectively a drop-in
replacement for a standard compiler like *gcc* or *clang*.

Command line syntax
===================

   emcc [options] file...

(Note that you will need "./emcc" if you want to run emcc from your
current directory.)

The input file(s) can be either source code files that *Clang* can
handle (C or C++), object files (produced by *emcc -c*), or LLVM
assembly files.

Arguments
---------

Most clang options will work, as will gcc options, for example:

emcc --help  
    Display this information

emcc --version
     Display compiler version information

To see the full list of *Clang* options supported on the version of
*Clang* used by Emscripten, run "clang --help".

Options that are modified or new in *emcc* are listed below:

"-O0"
   [compile+link] No optimizations (default). This is the recommended
   setting for starting to port a project, as it includes various
   assertions.

   This and other optimization settings are meaningful both during
   compile and during link. During compile it affects LLVM
   optimizations, and during link it affects final optimization of the
   code in Binaryen as well as optimization of the JS. (For fast
   incremental builds "-O0" is best, while for release you should link
   with something higher.)

"-O1"
   [compile+link] Simple optimizations. During the compile step these
   include LLVM "-O1" optimizations. During the link step this does
   not include various runtime assertions in JS that *-O0* would do.

"-O2"
   [compile+link] Like "-O1", but enables more optimizations. During
   link this will also enable various JavaScript optimizations.

   Note:

     These JavaScript optimizations can reduce code size by removing
     things that the compiler does not see being used, in particular,
     parts of the runtime may be stripped if they are not exported on
     the "Module" object. The compiler is aware of code in --pre-js
     and --post-js, so you can safely use the runtime from there.
     Alternatively, you can use "EXPORTED_RUNTIME_METHODS", see
     src/settings.js.

"-O3"
   [compile+link] Like "-O2", but with additional optimizations that
   may take longer to run.

   Note:

     This is a good setting for a release build.

"-Og"
   [compile+link] Like "-O1". In future versions, this option might
   disable different optimizations in order to improve debuggability.

"-Os"
   [compile+link] Like "-O3", but focuses more on code size (and may
   make tradeoffs with speed). This can affect both Wasm and
   JavaScript.

"-Oz"
   [compile+link] Like "-Os", but reduces code size even further, and
   may take longer to run. This can affect both Wasm and JavaScript.

   Note:

     For more tips on optimizing your code, see Optimizing Code.

"-sOPTION[=VALUE]"
   [different OPTIONs affect at different stages, most at link time]
   Emscripten build options. For the available options, see
   src/settings.js.

   Note:

     If no value is specified it will default to "1".

   Note:

     It is possible, with boolean options, to use the "NO_" prefix to
     reverse their meaning. For example, "-sEXIT_RUNTIME=0" is the
     same as "-sNO_EXIT_RUNTIME=1" and vice versa.  This is not
     recommended in most cases.

   Note:

     Lists can be specified as comma separated strings:

        -sEXPORTED_FUNCTIONS=foo,bar

   Note:

     We also support older list formats that involve more quoting.
     Lists can be specified with or without quotes around each element
     and with or without brackets around the list.  For example, all
     the following are equivalent:

        -sEXPORTED_FUNCTIONS="foo","bar"
        -sEXPORTED_FUNCTIONS=["foo","bar"]
        -sEXPORTED_FUNCTIONS=[foo,bar]

   Note:

     For lists that include brackets or quote, you need quotation
     marks (") around the list in most shells (to avoid errors being
     raised). Two examples are shown below:

        -sEXPORTED_FUNCTIONS="['liblib.so']"
        -s"EXPORTED_FUNCTIONS=['liblib.so']"

   You can also specify that the value of an option will be read from
   a file. For example, the following will set "EXPORTED_FUNCTIONS"
   based on the contents of the file at **path/to/file**.

      -sEXPORTED_FUNCTIONS=@/path/to/file

   Note:

     * In this case the file should contain a list of symbols, one per
       line.  For legacy use cases JSON-formatted files are also
       supported: e.g. "["_func1", "func2"]".

     * The specified file path must be absolute, not relative.

     * The file may contain comments where the first character of the
       line is "'#'".

   Note:

     Options can be specified as a single argument with or without a
     space between the "-s" and option name.  e.g. "-sFOO" or "-s
     FOO". It's highly recommended you use the notation without space.

"-g"
   [compile+link] Preserve debug information.

* When compiling to object files, this is the same as in *Clang*
     and *gcc*, it adds DWARF debug information to the object files.

* When linking, this is equivalent to -g3.

"-gseparate-dwarf[=FILENAME]"
   [same as -g3 if passed at compile time, otherwise applies at link]
   Preserve debug information, but in a separate file on the side.
   This is the same as "-g", but the main file will contain no debug
   info. Instead, debug info will be present in a file on the side, in
   "FILENAME" if provided, otherwise the same as the Wasm file but
   with suffix ".debug.wasm". While the main file contains no debug
   info, it does contain a URL to where the debug file is, so that
   devtools can find it. You can use "-sSEPARATE_DWARF_URL=URL" to
   customize that location (this is useful if you want to host it on a
   different server, for example).

"-gsplit-dwarf"
   Enable debug fission, which creates split DWARF object files
   alongside the wasm object files. This option must be used together
   with "-c".

"-gsource-map"
   [link] Generate a source map using LLVM debug information (which
   must be present in object files, i.e., they should have been
   compiled with "-g"). When this option is provided, the **.wasm**
   file is updated to have a "sourceMappingURL" section. The resulting
   URL will have format: "<base-url>" + "<wasm-file-name>" + ".map".
   "<base-url>" defaults to being empty (which means the source map is
   served from the same directory as the Wasm file). It can be changed
   using --source-map-base.

"-g<level>"
   [compile+link] Controls the level of debuggability. Each level
   builds on the previous one:

      * "-g0": Make no effort to keep code debuggable.

      * "-g1": When linking, preserve whitespace in JavaScript.

      * "-g2": When linking, preserve function names in compiled code.

      * "-g3": When compiling to object files, keep debug info,
        including JS whitespace, function names, and LLVM debug info
        (DWARF) if any (this is the same as -g).

"--profiling"
   [same as -g2 if passed at compile time, otherwise applies at link]
   Use reasonable defaults when emitting JavaScript to make the build
   readable but still useful for profiling. This sets "-g2" (preserve
   whitespace and function names) and may also enable optimizations
   that affect performance and otherwise might not be performed in
   "-g2".

"--profiling-funcs"
   [link] Preserve function names in profiling, but otherwise minify
   whitespace and names as we normally do in optimized builds. This is
   useful if you want to look at profiler results based on function
   names, but do *not* intend to read the emitted code.

"--tracing"
   [link] Enable the Emscripten Tracing API.

"--reproduce=<file.tar>"
   [compile+link] Write tar file containing inputs and command to
   reproduce invocation.  When sharing this file be aware that it will
   any object files, source files and libraries that that were passed
   to the compiler.

"--emit-symbol-map"
   [link] Save a map file between function indexes in the Wasm and
   function names. By storing the names on a file on the side, you can
   avoid shipping the names, and can still reconstruct meaningful
   stack traces by translating the indexes back to the names.

   Note:

     When used with "-sWASM=2", two symbol files are created.
     "[name].js.symbols" (with WASM symbols) and
     "[name].wasm.js.symbols" (with ASM.js symbols)

"-flto"
   [compile+link] Enables link-time optimizations (LTO).

"--closure 0|1|2"
   [link] Runs the *Closure Compiler*. Possible values are:

      * "0": No closure compiler (default in "-O2" and below).

      * "1": Run closure compiler. This greatly reduces the size of
        the support JavaScript code (everything but the WebAssembly or
        asm.js). Note that this increases compile time significantly.

      * "2": Run closure compiler on *all* the emitted code, even on
        **asm.js** output in **asm.js** mode. This can further reduce
        code size, but does prevent a significant amount of **asm.js**
        optimizations, so it is not recommended unless you want to
        reduce code size at all costs.

   Note:

     * Consider using "-sMODULARIZE" when using closure, as it
       minifies globals to names that might conflict with others in
       the global scope. "MODULARIZE" puts all the output into a
       function (see "src/settings.js").

     * Closure will minify the name of *Module* itself, by default!
       Using "MODULARIZE" will solve that as well. Another solution is
       to make sure a global variable called *Module* already exists
       before the closure-compiled code runs, because then it will
       reuse that variable.

     * Closure is only run if JavaScript opts are being done ("-O2" or
       above).

"--closure-args=<args>"
   [link] Pass arguments to the *Closure compiler*. This is an
   alternative to "EMCC_CLOSURE_ARGS".

   For example, one might want to pass an externs file to avoid
   minifying JS functions defined in "--pre-js" or "--post-js" files.
   To pass to Closure the "externs.js" file containing those public
   APIs that should not be minified, one would add the flag: "--
   closure-args=--externs=path/to/externs.js"

"--pre-js <file>"
   [link] Specify a file whose contents are added before the emitted
   code and optimized together with it. Note that this might not
   literally be the very first thing in the JS output, for example if
   "MODULARIZE" is used (see "src/settings.js"). If you want that, you
   can just prepend to the output from emscripten; the benefit of "--
   pre-js" is that it optimizes the code with the rest of the
   emscripten output, which allows better dead code elimination and
   minification, and it should only be used for that purpose. In
   particular, "--pre-js" code should not alter the main output from
   emscripten in ways that could confuse the optimizer, such as using
   "--pre-js" + "--post-js" to put all the output in an inner function
   scope (see "MODULARIZE" for that).

   *--pre-js* (but not *--post-js*) is also useful for specifying
   things on the "Module" object, as it appears before the JS looks at
   "Module" (for example, you can define "Module['print']" there).

"--post-js <file>"
   [link] Like "--pre-js", but emits a file *after* the emitted code.

"--extern-pre-js <file>"
   [link] Specify a file whose contents are prepended to the
   JavaScript output. This file is prepended to the final JavaScript
   output, *after* all other work has been done, including
   optimization, optional "MODULARIZE"-ation, instrumentation like
   "SAFE_HEAP", etc. This is the same as prepending this file after
   "emcc" finishes running, and is just a convenient way to do that.
   (For comparison, "--pre-js" and "--post-js" optimize the code
   together with everything else, keep it in the same scope if running
   *MODULARIZE*, etc.).

"--extern-post-js <file>"
   [link] Like "--extern-pre-js", but appends to the end.

"--embed-file <file>"
   [link] Specify a file (with path) to embed inside the generated
   WebAssembly module. The path is relative to the current directory
   at compile time. If a directory is passed here, its entire contents
   will be embedded.

   For example, if the command includes "--embed-file dir/file.dat",
   then "dir/file.dat" must exist relative to the directory where you
   run *emcc*.

   Note:

     Embedding files is generally more efficient than preloading as it
     avoids copying the file data at runtime.

   For more information about the "--embed-file" options, see
   Packaging Files.

"--preload-file <name>"
   [link] Specify a file to preload before running the compiled code
   asynchronously. The path is relative to the current directory at
   compile time. If a directory is passed here, its entire contents
   will be embedded.

   Preloaded files are stored in **filename.data**, where
   **filename.html** is the main file you are compiling to. To run
   your code, you will need both the **.html** and the **.data**.

   Note:

     This option is similar to --embed-file, except that it is only
     relevant when generating HTML (it uses asynchronous binary
     *XHRs*), or JavaScript that will be used in a web page.

   *emcc* runs tools/file_packager to do the actual packaging of
   embedded and preloaded files. You can run the file packager
   yourself if you want (see Packaging using the file packager tool).
   You should then put the output of the file packager in an emcc "--
   pre-js", so that it executes before your main compiled code.

   For more information about the "--preload-file" options, see
   Packaging Files.

"--exclude-file <name>"
   [link] Files and directories to be excluded from --embed-file and
   --preload-file. Wildcards (*) are supported.

"--use-preload-plugins"
   [link] Tells the file packager to run preload plugins on the files
   as they are loaded. This performs tasks like decoding images and
   audio using the browser's codecs.

"--shell-file <path>"
   [link] The path name to a skeleton HTML file used when generating
   HTML output. The shell file used needs to have this token inside
   it: "{{{ SCRIPT }}}".

   Note:

     * See src/shell.html and src/shell_minimal.html for examples.

     * This argument is ignored if a target other than HTML is
       specified using the "-o" option.

"--source-map-base <base-url>"
   [link] The base URL for the location where WebAssembly source maps
   will be published. Must be used with -gsource-map.

"--minify 0"
   [same as -g1 if passed at compile time, otherwise applies at link]
   Identical to "-g1".

"--js-transform <cmd>"
   [link] Specifies a "<cmd>" to be called on the generated code
   before it is optimized. This lets you modify the JavaScript, for
   example adding or removing some code, in a way that those
   modifications will be optimized together with the generated code.

   "<cmd>" will be called with the file name of the generated code as
   a parameter. To modify the code, you can read the original data and
   then append to it or overwrite it with the modified data.

   "<cmd>" is interpreted as a space-separated list of arguments, for
   example, "<cmd>" of **python processor.py** will cause a Python
   script to be run.

"--bind"
   [link] Links against embind library.  Deprecated: Use "-lembind"
   instead.

"--embind-emit-tsd <path>"
   [link] Generates TypeScript definition file.  Deprecated: Use "--
   emit-tsd" instead.

"--emit-tsd <path>"
   [link] Generate a TypeScript definition file for the emscripten
   module. The definition file will include exported Wasm functions,
   runtime exports, and exported embind bindings (if used). In order
   to generate bindings from embind, the program will be instrumented
   and run in node.

"--ignore-dynamic-linking"
   [link] Tells the compiler to ignore dynamic linking (the user will
   need to manually link to the shared libraries later on).

   Normally *emcc* will simply link in code from the dynamic library
   as though it were statically linked, which will fail if the same
   dynamic library is linked more than once. With this option, dynamic
   linking is ignored, which allows the build system to proceed
   without errors.

"--js-library <lib>"
   [link] A JavaScript library to use in addition to those in
   Emscripten's core libraries (src/library_*).

"-v"
   [general] Turns on verbose output.

   This will print the internal sub-commands run by emscripten as well
   as "-v" to *Clang*.

   Tip:

     "emcc -v" is a useful tool for diagnosing errors. It works with
     or without other arguments.

"--check"
   [general] Runs Emscripten's internal sanity checks and reports any
   issues with the current configuration.

"--cache <directory>"
   [general] Sets the directory to use as the Emscripten cache. The
   Emscripten cache is used to store pre-built versions of "libc",
   "libcxx" and other libraries.

   If using this in combination with "--clear-cache", be sure to
   specify this argument first.

   The Emscripten cache defaults to "emscripten/cache" but can be
   overridden using the "EM_CACHE" environment variable or "CACHE"
   config setting.

"--clear-cache"
   [general] Manually clears the cache of compiled Emscripten system
   libraries (libc++, libc++abi, libc).

   This is normally handled automatically, but if you update LLVM in-
   place (instead of having a different directory for a new version),
   the caching mechanism can get confused. Clearing the cache can fix
   weird problems related to cache incompatibilities, like *Clang*
   failing to link with library files. This also clears other cached
   data. After the cache is cleared, this process will exit.

   By default this will also clear any download ports since the ports
   directory is usually within the cache directory.

"--use-port=<port>"
   [compile+link] Use the specified port. If you need to use more than
   one port you can use this option multiple times (ex: "--use-
   port=sdl2 --use-port=bzip2"). A port can have options separated by
   ":" (ex: "--use-port=sdl2_image:formats=png,jpg"). To use an
   external port, you provide the path to the port directly (ex: "--
   use-port=/path/to/my_port.py"). To get more information about a
   port, use the "help" option (ex: "--use-port=sdl2_image:help"). To
   get the list of available ports, use "--show-ports".

"--clear-ports"
   [general] Manually clears the local copies of ports from the
   Emscripten Ports repos (sdl2, etc.). This also clears the cache, to
   remove their builds.

   You should only need to do this if a problem happens and you want
   all ports that you use to be downloaded and built from scratch.
   After this operation is complete, this process will exit.

"--show-ports"
   [general] Shows the list of available projects in the Emscripten
   Ports repos. After this operation is complete, this process will
   exit.

"-Wwarn-absolute-paths"
   [compile+link] Enables warnings about the use of absolute paths in
   "-I" and "-L" command line directives. This is used to warn against
   unintentional use of absolute paths, which is sometimes dangerous
   when referring to nonportable local system headers.

"--proxy-to-worker"
   [link] Runs the main application code in a worker, proxying events
   to it and output from it. If emitting HTML, this emits a **.html**
   file, and a separate **.js** file containing the JavaScript to be
   run in a worker. If emitting JavaScript, the target file name
   contains the part to be run on the main thread, while a second
   **.js** file with suffix ".worker.js" will contain the worker
   portion.

"--emrun"
   [link] Enables the generated output to be aware of the emrun
   command line tool. This allows "stdout", "stderr" and
   "exit(returncode)" capture when running the generated application
   through *emrun*. (This enables *EXIT_RUNTIME=1*, allowing normal
   runtime exiting with return code passing.)

"--cpuprofiler"
   [link] Embeds a simple CPU profiler onto the generated page. Use
   this to perform cursory interactive performance profiling.

"--memoryprofiler"
   [link] Embeds a memory allocation tracker onto the generated page.
   Use this to profile the application usage of the Emscripten HEAP.

"--threadprofiler"
   [link] Embeds a thread activity profiler onto the generated page.
   Use this to profile the application usage of pthreads when
   targeting multithreaded builds (-pthread).

"--em-config <path>"
   [general] Specifies the location of the **.emscripten**
   configuration file.  If not specified emscripten will search for
   ".emscripten" first in the emscripten directory itself, and then in
   the user's home directory ("~/.emscripten"). This can be overridden
   using the "EM_CONFIG" environment variable.

"--valid-abspath <path>"
   [compile+link] Note an allowed absolute path, which we should not
   warn about (absolute include paths normally are warned about, since
   they may refer to the local system headers etc. which we need to
   avoid when cross-compiling).

"-o <target>"
   [link] When linking an executable, the "target" file name extension
   defines the output type to be generated:

      * <name> **.js** : JavaScript (+ separate **<name>.wasm** file
        if emitting WebAssembly). (default)

      * <name> **.mjs** : ES6 JavaScript module (+ separate
        **<name>.wasm** file if emitting WebAssembly).

      * <name> **.html** : HTML + separate JavaScript file
        (**<name>.js**; + separate **<name>.wasm** file if emitting
        WebAssembly).

      * <name> **.wasm** : WebAssembly without JavaScript support code
        ("standalone Wasm"; this enables "STANDALONE_WASM").

   These rules only apply when linking.  When compiling to object code
   (See *-c* below) the name of the output file is irrelevant.

"-c"
   [compile] Tells *emcc* to emit an object file which can then be
   linked with other object files to produce an executable.

"--output_eol windows|linux"
   [link] Specifies the line ending to generate for the text files
   that are outputted. If "--output_eol windows" is passed, the final
   output files will have Windows rn line endings in them. With "--
   output_eol linux", the final generated files will be written with
   Unix n line endings.

"--cflags"
   [other] Prints out the flags "emcc" would pass to "clang" to
   compile source code to object form. You can use this to invoke
   clang yourself, and then run "emcc" on those outputs just for the
   final linking+conversion to JS.

Environment variables
=====================

*emcc* is affected by several environment variables, as listed below:

* "EMMAKEN_JUST_CONFIGURE" [other]

* "EMCC_AUTODEBUG" [compile+link]

* "EMCC_CFLAGS" [compile+link]

* "EMCC_CORES" [general]

* "EMCC_DEBUG" [general]

* "EMCC_DEBUG_SAVE" [general]

* "EMCC_FORCE_STDLIBS" [link]

* "EMCC_ONLY_FORCED_STDLIBS" [link]

* "EMCC_LOCAL_PORTS" [compile+link]

* "EMCC_STDERR_FILE" [general]

* "EMCC_CLOSURE_ARGS" [link] arguments to be passed to *Closure
     Compiler*

* "EMCC_STRICT" [general]

* "EMCC_SKIP_SANITY_CHECK" [general]

* "EM_IGNORE_SANITY" [general]

* "EM_CONFIG" [general]

* "EM_LLVM_ROOT" [compile+link]

* "_EMCC_CCACHE" [general] Internal setting that is set to 1 by
     emsdk when integrating with ccache compiler frontend

Search for 'os.environ' in emcc.py to see how these are used. The most
interesting is possibly "EMCC_DEBUG", which forces the compiler to
dump its build and temporary files to a temporary directory where they
can be reviewed.

------------------------------------------------------------------

emcc: supported targets: llvm bitcode, WebAssembly, NOT elf

## opencv js python cmake_options options

DO NOT OVERWRITE "-DCMAKE_TOOLCHAIN_FILE" as it is required for emscripten to work.

See <https://docs.opencv.org/4.x/db/d05/tutorial_config_reference.html>

Generated options from all available options:

``` bash
# initial configuration
cmake ../opencv
 
# print all options
cmake -L
 
# print all options with help message
cmake -LH
 
# print all options including advanced
cmake -LA

```

### OpenCV cmake options

OCV_OPTION(OPENCV_ENABLE_NONFREE "Enable non-free algorithms" OFF)

### OpenCV build options

OCV_OPTION(ENABLE_CCACHE              "Use ccache"                                               (UNIX AND (CMAKE_GENERATOR MATCHES "Makefile" OR CMAKE_GENERATOR MATCHES "Ninja" OR CMAKE_GENERATOR MATCHES "Xcode")) )
OCV_OPTION(ENABLE_PRECOMPILED_HEADERS "Use precompiled headers"                                  MSVC IF (MSVC OR (NOT IOS AND NOT XROS AND NOT CMAKE_CROSSCOMPILING) ) )
OCV_OPTION(ENABLE_DELAYLOAD           "Enable delayed loading of OpenCV DLLs"                    OFF VISIBLE_IF MSVC AND BUILD_SHARED_LIBS)
OCV_OPTION(ENABLE_SOLUTION_FOLDERS    "Solution folder in Visual Studio or in other IDEs"        (MSVC_IDE OR CMAKE_GENERATOR MATCHES Xcode) )
OCV_OPTION(ENABLE_PROFILING           "Enable profiling in the GCC compiler (Add flags: -g -pg)" OFF  IF CV_GCC )
OCV_OPTION(ENABLE_COVERAGE            "Enable coverage collection with  GCov"                    OFF  IF CV_GCC )
OCV_OPTION(OPENCV_ENABLE_MEMORY_SANITIZER "Better support for memory/address sanitizers"         OFF)
OCV_OPTION(ENABLE_OMIT_FRAME_POINTER  "Enable -fomit-frame-pointer for GCC"                      ON   IF CV_GCC )
OCV_OPTION(ENABLE_POWERPC             "Enable PowerPC for GCC"                                   ON   IF (CV_GCC AND CMAKE_SYSTEM_PROCESSOR MATCHES powerpc.*) )
OCV_OPTION(ENABLE_FAST_MATH           "Enable compiler options for fast math optimizations on FP computations (not recommended)" OFF)
if(NOT IOS AND (NOT ANDROID OR OPENCV_ANDROID_USE_LEGACY_FLAGS) AND CMAKE_CROSSCOMPILING)  # Use CPU_BASELINE instead
OCV_OPTION(ENABLE_NEON                "Enable NEON instructions"                                 (NEON OR ANDROID_ARM_NEON OR AARCH64) IF (CV_GCC OR CV_CLANG) AND (ARM OR AARCH64 OR IOS OR XROS) )
OCV_OPTION(ENABLE_VFPV3               "Enable VFPv3-D32 instructions"                            OFF  IF (CV_GCC OR CV_CLANG) AND (ARM OR AARCH64 OR IOS OR XROS) )
endif()
OCV_OPTION(ENABLE_NOISY_WARNINGS      "Show all warnings even if they are too noisy"             OFF )
OCV_OPTION(OPENCV_WARNINGS_ARE_ERRORS "Treat warnings as errors"                                 OFF )
OCV_OPTION(ANDROID_EXAMPLES_WITH_LIBS "Build binaries of Android examples with native libraries" OFF  IF ANDROID )
OCV_OPTION(ENABLE_IMPL_COLLECTION     "Collect implementation data on function call"             OFF )
OCV_OPTION(ENABLE_INSTRUMENTATION     "Instrument functions to collect calls trace and performance" OFF )
OCV_OPTION(ENABLE_GNU_STL_DEBUG       "Enable GNU STL Debug mode (defines _GLIBCXX_DEBUG)"       OFF IF CV_GCC )
OCV_OPTION(ENABLE_BUILD_HARDENING     "Enable hardening of the resulting binaries (against security attacks, detects memory corruption, etc)" OFF)
OCV_OPTION(ENABLE_LTO                 "Enable Link Time Optimization" OFF IF CV_GCC OR MSVC)
OCV_OPTION(ENABLE_THIN_LTO            "Enable Thin LTO" OFF IF CV_CLANG)
OCV_OPTION(GENERATE_ABI_DESCRIPTOR    "Generate XML file for abi_compliance_checker tool" OFF IF UNIX)
OCV_OPTION(OPENCV_GENERATE_PKGCONFIG  "Generate .pc file for pkg-config build tool (deprecated)" OFF)
OCV_OPTION(CV_ENABLE_INTRINSICS       "Use intrinsic-based optimized code" ON )
OCV_OPTION(CV_DISABLE_OPTIMIZATION    "Disable explicit optimized code (dispatched code/intrinsics/loop unrolling/etc)" OFF )
OCV_OPTION(CV_TRACE                   "Enable OpenCV code trace" ON)
OCV_OPTION(OPENCV_GENERATE_SETUPVARS  "Generate setup_vars* scripts" ON IF (NOT ANDROID AND NOT APPLE_FRAMEWORK) )
OCV_OPTION(ENABLE_CONFIG_VERIFICATION "Fail build if actual configuration doesn't match requested (WITH_XXX != HAVE_XXX)" OFF)
OCV_OPTION(OPENCV_ENABLE_MEMALIGN     "Enable posix_memalign or memalign usage" ON)
OCV_OPTION(OPENCV_DISABLE_FILESYSTEM_SUPPORT "Disable filesystem support" OFF)
OCV_OPTION(OPENCV_DISABLE_THREAD_SUPPORT "Build the library without multi-threaded code." OFF)
OCV_OPTION(OPENCV_SEMIHOSTING         "Build the library for semihosting target (Arm). See <https://developer.arm.com/documentation/100863/latest>." OFF)
OCV_OPTION(ENABLE_CUDA_FIRST_CLASS_LANGUAGE "Enable CUDA as a first class language, if enabled dependant projects will need to use CMake >= 3.18" OFF
  VISIBLE_IF (WITH_CUDA AND NOT CMAKE_VERSION VERSION_LESS 3.18)
  VERIFY HAVE_CUDA)

OCV_OPTION(ENABLE_PYLINT              "Add target with Pylint checks"                            (BUILD_DOCS OR BUILD_EXAMPLES) IF (NOT CMAKE_CROSSCOMPILING AND NOT APPLE_FRAMEWORK) )
OCV_OPTION(ENABLE_FLAKE8              "Add target with Python flake8 checker"                    (BUILD_DOCS OR BUILD_EXAMPLES) IF (NOT CMAKE_CROSSCOMPILING AND NOT APPLE_FRAMEWORK) )

### 3rd party libs

OCV_OPTION(OPENCV_FORCE_3RDPARTY_BUILD   "Force using 3rdparty code from source" OFF)
OCV_OPTION(BUILD_ZLIB               "Build zlib from source"             (WIN32 OR APPLE OR OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_TIFF               "Build libtiff from source"          (WIN32 OR ANDROID OR APPLE OR OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_OPENJPEG           "Build OpenJPEG from source"         (WIN32 OR ANDROID OR APPLE OR OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_JASPER             "Build libjasper from source"        (WIN32 OR ANDROID OR APPLE OR OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_JPEG               "Build libjpeg from source"          (WIN32 OR ANDROID OR APPLE OR OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_PNG                "Build libpng from source"           (WIN32 OR ANDROID OR APPLE OR OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_OPENEXR            "Build openexr from source"          (OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_WEBP               "Build WebP from source"             (((WIN32 OR ANDROID OR APPLE) AND NOT WINRT) OR OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_TBB                "Download and build TBB from source" (ANDROID OR OPENCV_FORCE_3RDPARTY_BUILD) )
OCV_OPTION(BUILD_IPP_IW             "Build IPP IW from source"           (NOT MINGW OR OPENCV_FORCE_3RDPARTY_BUILD) IF (X86_64 OR X86) AND NOT WINRT )
OCV_OPTION(BUILD_ITT                "Build Intel ITT from source"
    (NOT MINGW OR OPENCV_FORCE_3RDPARTY_BUILD)
    IF (X86_64 OR X86 OR ARM OR AARCH64 OR PPC64 OR PPC64LE) AND NOT WINRT AND NOT APPLE_FRAMEWORK
)

### Optional 3rd party components

OCV_OPTION(WITH_1394 "Include IEEE1394 support" ON
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_DC1394_2)
OCV_OPTION(WITH_AVFOUNDATION "Use AVFoundation for Video I/O (iOS/visionOS/Mac)" ON
  VISIBLE_IF APPLE
  VERIFY HAVE_AVFOUNDATION)
OCV_OPTION(WITH_AVIF "Enable AVIF support" OFF
  VERIFY HAVE_AVIF)
OCV_OPTION(WITH_CAP_IOS "Enable iOS video capture" ON
  VISIBLE_IF IOS
  VERIFY HAVE_CAP_IOS)
OCV_OPTION(WITH_CAROTENE "Use NVidia carotene acceleration library for ARM platform" (NOT CV_DISABLE_OPTIMIZATION)
  VISIBLE_IF (ARM OR AARCH64) AND NOT IOS AND NOT XROS)
OCV_OPTION(WITH_KLEIDICV "Use KleidiCV library for ARM platforms" OFF
  VISIBLE_IF (AARCH64 AND (ANDROID OR UNIX AND NOT IOS AND NOT XROS)))
OCV_OPTION(WITH_NDSRVP "Use Andes RVP extension" (NOT CV_DISABLE_OPTIMIZATION)
  VISIBLE_IF RISCV)
OCV_OPTION(WITH_CPUFEATURES "Use cpufeatures Android library" ON
  VISIBLE_IF ANDROID
  VERIFY HAVE_CPUFEATURES)
OCV_OPTION(WITH_VTK "Include VTK library support (and build opencv_viz module eiher)" ON
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT AND NOT CMAKE_CROSSCOMPILING
  VERIFY HAVE_VTK)
OCV_OPTION(WITH_CUDA "Include NVidia Cuda Runtime support" OFF
  VISIBLE_IF NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_CUDA)
OCV_OPTION(WITH_CUFFT "Include NVidia Cuda Fast Fourier Transform (FFT) library support" WITH_CUDA
  VISIBLE_IF WITH_CUDA
  VERIFY HAVE_CUFFT)
OCV_OPTION(WITH_CUBLAS "Include NVidia Cuda Basic Linear Algebra Subprograms (BLAS) library support" WITH_CUDA
  VISIBLE_IF WITH_CUDA
  VERIFY HAVE_CUBLAS)
OCV_OPTION(WITH_CUDNN "Include NVIDIA CUDA Deep Neural Network (cuDNN) library support" WITH_CUDA
  VISIBLE_IF WITH_CUDA
  VERIFY HAVE_CUDNN)
OCV_OPTION(WITH_NVCUVID "Include NVidia Video Decoding library support" ON
  VISIBLE_IF WITH_CUDA
  VERIFY HAVE_NVCUVID)
OCV_OPTION(WITH_NVCUVENC "Include NVidia Video Encoding library support" ON
  VISIBLE_IF WITH_CUDA
  VERIFY HAVE_NVCUVENC)
OCV_OPTION(WITH_EIGEN "Include Eigen2/Eigen3 support" (NOT CV_DISABLE_OPTIMIZATION AND NOT CMAKE_CROSSCOMPILING)
  VISIBLE_IF NOT WINRT
  VERIFY HAVE_EIGEN)
OCV_OPTION(WITH_FFMPEG "Include FFMPEG support" (NOT ANDROID)
  VISIBLE_IF NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_FFMPEG)
OCV_OPTION(WITH_GSTREAMER "Include Gstreamer support" ON
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_GSTREAMER AND GSTREAMER_VERSION VERSION_GREATER "0.99")
OCV_OPTION(WITH_GTK "Include GTK support" ON
  VISIBLE_IF UNIX AND NOT APPLE AND NOT ANDROID
  VERIFY HAVE_GTK)
OCV_OPTION(WITH_GTK_2_X "Use GTK version 2" OFF
  VISIBLE_IF UNIX AND NOT APPLE AND NOT ANDROID
  VERIFY HAVE_GTK AND NOT HAVE_GTK3)
OCV_OPTION(WITH_WAYLAND "Include Wayland support" OFF
        VISIBLE_IF UNIX AND NOT APPLE AND NOT ANDROID
        VERIFY HAVE_WAYLAND)
OCV_OPTION(WITH_IPP "Include Intel IPP support" (NOT MINGW AND NOT CV_DISABLE_OPTIMIZATION)
  VISIBLE_IF (X86_64 OR X86) AND NOT WINRT AND NOT IOS AND NOT XROS
  VERIFY HAVE_IPP)
OCV_OPTION(WITH_HALIDE "Include Halide support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_HALIDE)
OCV_OPTION(WITH_VULKAN "Include Vulkan support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_VULKAN)

### replacement for deprecated options: WITH_INF_ENGINE, WITH_NGRAPH

OCV_OPTION(WITH_OPENVINO "Include Intel OpenVINO toolkit support" (WITH_INF_ENGINE)
  VISIBLE_IF TRUE
  VERIFY TARGET ocv.3rdparty.openvino)
OCV_OPTION(WITH_WEBNN "Include WebNN support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_WEBNN)
OCV_OPTION(WITH_JASPER "Include JPEG2K support (Jasper)" ON
  VISIBLE_IF NOT IOS AND NOT XROS
  VERIFY HAVE_JASPER)
OCV_OPTION(WITH_OPENJPEG "Include JPEG2K support (OpenJPEG)" ON
  VISIBLE_IF NOT IOS AND NOT XROS
  VERIFY HAVE_OPENJPEG)
OCV_OPTION(WITH_JPEG "Include JPEG support" ON
  VISIBLE_IF TRUE
  VERIFY HAVE_JPEG)
OCV_OPTION(WITH_WEBP "Include WebP support" ON
  VISIBLE_IF NOT WINRT
  VERIFY HAVE_WEBP)
OCV_OPTION(WITH_OPENEXR "Include ILM support via OpenEXR" ((WIN32 OR ANDROID OR APPLE) OR BUILD_OPENEXR) OR NOT CMAKE_CROSSCOMPILING
  VISIBLE_IF NOT APPLE_FRAMEWORK AND NOT WINRT
  VERIFY HAVE_OPENEXR)
OCV_OPTION(WITH_OPENGL "Include OpenGL support" OFF
  VISIBLE_IF NOT ANDROID AND NOT WINRT
  VERIFY HAVE_OPENGL)
OCV_OPTION(WITH_OPENVX "Include OpenVX support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_OPENVX)
OCV_OPTION(WITH_OPENNI "Include OpenNI support" OFF
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_OPENNI)
OCV_OPTION(WITH_OPENNI2 "Include OpenNI2 support" OFF
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_OPENNI2)
OCV_OPTION(WITH_PNG "Include PNG support" ON
  VISIBLE_IF TRUE
  VERIFY HAVE_PNG)
OCV_OPTION(WITH_SPNG "Include SPNG support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_SPNG)
OCV_OPTION(WITH_GDCM "Include DICOM support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_GDCM)
OCV_OPTION(WITH_PVAPI "Include Prosilica GigE support" OFF
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_PVAPI)
OCV_OPTION(WITH_ARAVIS "Include Aravis GigE support" OFF
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT AND NOT WIN32
  VERIFY HAVE_ARAVIS_API)
OCV_OPTION(WITH_QT "Build with Qt Backend support" OFF
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_QT)
OCV_OPTION(WITH_WIN32UI "Build with Win32 UI Backend support" ON
  VISIBLE_IF WIN32 AND NOT WINRT
  VERIFY HAVE_WIN32UI)
OCV_OPTION(WITH_TBB "Include Intel TBB support" OFF
  VISIBLE_IF NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_TBB)
OCV_OPTION(WITH_HPX "Include Ste||ar Group HPX support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_HPX)
OCV_OPTION(WITH_OPENMP "Include OpenMP support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_OPENMP)
OCV_OPTION(WITH_PTHREADS_PF "Use pthreads-based parallel_for" ON
  VISIBLE_IF NOT WIN32 OR MINGW
  VERIFY HAVE_PTHREADS_PF)
OCV_OPTION(WITH_TIFF "Include TIFF support" ON
  VISIBLE_IF NOT IOS AND NOT XROS
  VERIFY HAVE_TIFF)
OCV_OPTION(WITH_V4L "Include Video 4 Linux support" ON
  VISIBLE_IF UNIX AND NOT ANDROID AND NOT APPLE
  VERIFY HAVE_CAMV4L OR HAVE_CAMV4L2 OR HAVE_VIDEOIO)
OCV_OPTION(WITH_DSHOW "Build VideoIO with DirectShow support" ON
  VISIBLE_IF WIN32 AND NOT ARM AND NOT WINRT
  VERIFY HAVE_DSHOW)
OCV_OPTION(WITH_MSMF "Build VideoIO with Media Foundation support" NOT MINGW
  VISIBLE_IF WIN32
  VERIFY HAVE_MSMF)
OCV_OPTION(WITH_MSMF_DXVA "Enable hardware acceleration in Media Foundation backend" WITH_MSMF
  VISIBLE_IF WIN32
  VERIFY HAVE_MSMF_DXVA)
OCV_OPTION(WITH_XIMEA "Include XIMEA cameras support" OFF
  VISIBLE_IF NOT ANDROID AND NOT WINRT
  VERIFY HAVE_XIMEA)
OCV_OPTION(WITH_UEYE "Include UEYE camera support" OFF
  VISIBLE_IF NOT ANDROID AND NOT APPLE AND NOT WINRT
  VERIFY HAVE_UEYE)
OCV_OPTION(WITH_XINE "Include Xine support (GPL)" OFF
  VISIBLE_IF UNIX AND NOT APPLE AND NOT ANDROID
  VERIFY HAVE_XINE)
OCV_OPTION(WITH_CLP "Include Clp support (EPL)" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_CLP)
OCV_OPTION(WITH_OPENCL "Include OpenCL Runtime support" (NOT ANDROID AND NOT CV_DISABLE_OPTIMIZATION)
  VISIBLE_IF NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_OPENCL)
OCV_OPTION(WITH_OPENCL_SVM "Include OpenCL Shared Virtual Memory support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_OPENCL_SVM) # experimental
OCV_OPTION(WITH_OPENCLAMDFFT "Include AMD OpenCL FFT library support" ON
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_CLAMDFFT)
OCV_OPTION(WITH_OPENCLAMDBLAS "Include AMD OpenCL BLAS library support" ON
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_CLAMDBLAS)
OCV_OPTION(WITH_DIRECTX "Include DirectX support" ON
  VISIBLE_IF WIN32 AND NOT WINRT
  VERIFY HAVE_DIRECTX)
OCV_OPTION(WITH_DIRECTML "Include DirectML support" ON
  VISIBLE_IF WIN32 AND NOT WINRT
  VERIFY HAVE_DIRECTML)
OCV_OPTION(WITH_OPENCL_D3D11_NV "Include NVIDIA OpenCL D3D11 support" WITH_DIRECTX
  VISIBLE_IF WIN32 AND NOT WINRT
  VERIFY HAVE_OPENCL_D3D11_NV)
OCV_OPTION(WITH_LIBREALSENSE "Include Intel librealsense support" OFF
  VISIBLE_IF NOT WITH_INTELPERC
  VERIFY HAVE_LIBREALSENSE)
OCV_OPTION(WITH_VA "Include VA support" (X86_64 OR X86)
  VISIBLE_IF UNIX AND NOT APPLE AND NOT ANDROID
  VERIFY HAVE_VA)
OCV_OPTION(WITH_VA_INTEL "Include Intel VA-API/OpenCL support" (X86_64 OR X86)
  VISIBLE_IF UNIX AND NOT APPLE AND NOT ANDROID
  VERIFY HAVE_VA_INTEL)
OCV_OPTION(WITH_MFX "Include Intel Media SDK support" OFF
  VISIBLE_IF (UNIX AND NOT ANDROID) OR (WIN32 AND NOT WINRT AND NOT MINGW)
  VERIFY HAVE_MFX)
OCV_OPTION(WITH_GDAL "Include GDAL Support" OFF
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS AND NOT WINRT
  VERIFY HAVE_GDAL)
OCV_OPTION(WITH_GPHOTO2 "Include gPhoto2 library support" OFF
  VISIBLE_IF UNIX AND NOT ANDROID AND NOT IOS AND NOT XROS
  VERIFY HAVE_GPHOTO2)
OCV_OPTION(WITH_LAPACK "Include Lapack library support" (NOT CV_DISABLE_OPTIMIZATION)
  VISIBLE_IF NOT ANDROID AND NOT IOS AND NOT XROS
  VERIFY HAVE_LAPACK)
OCV_OPTION(WITH_ITT "Include Intel ITT support" ON
  VISIBLE_IF NOT APPLE_FRAMEWORK
  VERIFY HAVE_ITT)
OCV_OPTION(WITH_PROTOBUF "Enable libprotobuf" ON
  VISIBLE_IF TRUE
  VERIFY HAVE_PROTOBUF)
OCV_OPTION(WITH_IMGCODEC_HDR "Include HDR support" ON
  VISIBLE_IF TRUE
  VERIFY HAVE_IMGCODEC_HDR)
OCV_OPTION(WITH_IMGCODEC_SUNRASTER "Include SUNRASTER support" ON
  VISIBLE_IF TRUE
  VERIFY HAVE_IMGCODEC_SUNRASTER)
OCV_OPTION(WITH_IMGCODEC_PXM "Include PNM (PBM,PGM,PPM) and PAM formats support" ON
  VISIBLE_IF TRUE
  VERIFY HAVE_IMGCODEC_PXM)
OCV_OPTION(WITH_IMGCODEC_PFM "Include PFM formats support" ON
  VISIBLE_IF TRUE
  VERIFY HAVE_IMGCODEC_PFM)
OCV_OPTION(WITH_QUIRC "Include library QR-code decoding" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_QUIRC)
OCV_OPTION(WITH_ANDROID_MEDIANDK "Use Android Media NDK for Video I/O (Android)" (ANDROID_NATIVE_API_LEVEL GREATER 20)
  VISIBLE_IF ANDROID
  VERIFY HAVE_ANDROID_MEDIANDK)
OCV_OPTION(WITH_ANDROID_NATIVE_CAMERA "Use Android NDK for Camera I/O (Android)" (ANDROID_NATIVE_API_LEVEL GREATER 23)
  VISIBLE_IF ANDROID
  VERIFY HAVE_ANDROID_NATIVE_CAMERA)
OCV_OPTION(WITH_ONNX "Include Microsoft ONNX Runtime support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_ONNX)
OCV_OPTION(WITH_TIMVX "Include Tim-VX support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_TIMVX)

### Attention when OBSENSOR_USE_ORBBEC_SDK set to off

### Astra2 cameras currently only support Windows and Linux kernel versions no higher than 4.15, and higher versions of Linux kernel may have exceptions

OCV_OPTION(OBSENSOR_USE_ORBBEC_SDK "Use Orbbec SDK as backend to support more camera models and platforms (force to ON on MacOS)" OFF)
OCV_OPTION(WITH_OBSENSOR "Include obsensor support (Orbbec 3D Cameras)" ON
  VISIBLE_IF (WIN32 AND NOT ARM AND NOT WINRT AND NOT MINGW) OR ( UNIX AND NOT APPLE AND NOT ANDROID) OR (APPLE AND AARCH64 AND NOT IOS)
  VERIFY HAVE_OBSENSOR)
OCV_OPTION(WITH_CANN "Include CANN support" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_CANN)
OCV_OPTION(WITH_FLATBUFFERS "Include Flatbuffers support (required by DNN/TFLite importer)" ON
  VISIBLE_IF TRUE
  VERIFY HAVE_FLATBUFFERS)
OCV_OPTION(WITH_ZLIB_NG "Use zlib-ng instead of zlib" OFF
  VISIBLE_IF TRUE
  VERIFY HAVE_ZLIB_NG)

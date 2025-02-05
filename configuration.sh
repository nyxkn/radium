
########################################################
#
#
#  Configuration. (default values)
#
#  You might want to edit this file if building Radium.
#
#  If developing Radium it's probably better to create
#  a script that sets your values and let that script
#  start the build process.
#
#  Variables are not overwritten in this file, they
#  only provide the default values. This can be
#  convenient e.g if you want to create different
#  scripts for building different versions of Radium,
#  or you don't want to risk accidentally pusing changes
#  in this file to the repository.
#
########################################################


# (do some stuff first)
ORG_PWD=`pwd`
cd $(dirname $0)
source helpers.sh




########################################################
# If set to 1, use clang/clang++ instead of gcc/g++
#
set_var RADIUM_USE_CLANG 0



########################################################
# If enabled, include the Pd instrument
# Only Linux. Other platforms ignore this variable.
#
set_var INCLUDE_PDDEV 1




########################################################
# If enabled, include the FaustDev instrument.
#
set_var INCLUDE_FAUSTDEV 1




########################################################
# If you want to include the FaustDev instrument,
# but don't want to support the llvm backend for it,
# then set the variable to 1. Without LLVM, faust
# can only use the slower interpreter backend.
#
set_var INCLUDE_FAUSTDEV_BUT_NOT_LLVM 0




########################################################
# If enabled, use QWebEngine instead of QtWebKit
#
# QWebEngine doesn't work as well as QtWebKit in Radium,
# but it can be enabled if you don't bother installing
# qt-webkit. (Installing QtWebKit can be quite a hassle
# sometimes!)
#
set_var USE_QWEBENGINE 0



########################################################
# Set to 0 to make the demo version of the program.
#
# The demo version has the following three restrictions:
#
# 1. "Export soundfile(s)" in the file menu is disabled.
# 2. Only two VST/VST3/AU/LV2 plugins can run at
#    the same time in a song. (Note: There are no
#    restrictions on the number of Ladspa plugins or
#    built-in plugins.)
# 3. A "nag" window requesting you to buy the program
#    shows up at program startup and after each time
#    you save a song.
#
# If you want to make a package for a large Linux
# distribution such as Ubuntu; Or, if you want to
# include Radium in Homebrew or Macports on macOS:
# I would kindly request that you set this value to 0.
#
set_var FULL_VERSION 1




########################################################
# A directory where qt5 is installed.
# If not set, we will try to find it automatically.
# Note that you might also have to set the
# PKGqt variable, pointing to a pkg-config binary
# that points to this version of Qt.
#
set_var RADIUM_QTDIR 0
set_var PKGqt 0



########################################################
# Set to the minimum Macos version you want the program
# to run on. (Obviously ignored on the other platforms)
#
if uname -s |grep Darwin ; then    
    set_var MACOSX_DEPLOYMENT_TARGET 12.0
fi




########################################################
#
# Values below here should often/usually work without modification.
#
########################################################


set_var PYTHONEXE `./find_python_path.sh`
assert_env_path_exists PYTHONEXE

set_var PKG `which pkg-config`
assert_env_path_exists PKG

if ! is_set PKGqt ; then
    export PKGqt=$PKG
fi

assert_env_path_exists PKGqt

if is_set INCLUDE_FAUSTDEV ; then
    if ! is_set INCLUDE_FAUSTDEV_BUT_NOT_LLVM ; then
	export FAUST_USES_LLVM="jadda"
    fi
fi


if is_set FAUST_USES_LLVM ; then
    
    set_var LLVM_CONFIG_BIN `which llvm-config`
    assert_env_path_exists LLVM_CONFIG_BIN
    
    if uname -s |grep Linux ; then
	
	set_var FAUST_LD_LIB_PATH "LD_LIBRARY_PATH=`${LLVM_CONFIG_BIN} --libdir`:$LD_LIBRARY_PATH"
	
    elif uname -s |grep Darwin ; then

	set_var FAUST_LD_LIB_PATH "DYLD_LIBRARY_PATH=`${LLVM_CONFIG_BIN} --libdir`:$DYLD_LIBRARY_PATH"

    else
	print_error_and_exit "unknown architecture"
    fi
    
fi


if uname -s |grep Darwin ; then
    
    if is_set FAUST_USES_LLVM ; then
	export MACOS_LLVM_TARGET=`${LLVM_CONFIG_BIN} --host-target`
    else
	export MACOS_LLVM_TARGET="Thiscodeisnotsupposedtobecompiled"
    fi
    
fi



########################################################
# Values below here should normally not be edited.
#
########################################################

# (Currently no point setting it another value than 5.)
export RADIUM_QT_VERSION=5


if [[ $RADIUM_USE_CLANG == 1 ]] ; then
    export FULL_CCC_PATH=`which clang++`
else
    export FULL_CCC_PATH=`which g++`
fi

if ! uname -s |grep Linux ; then
    unset INCLUDE_PDDEV
fi

if [ "${FULL_VERSION}" -eq "0" ] ; then
    true
elif [ "${FULL_VERSION}" -eq "1" ] ; then
    true
else
    print_error_and_exit "FULL_VERSION must be 0 or 1: ${FULL_VERSION}"
fi

# Used by the makefile
export ALL_SHELL_SCRIPTS=$(ls -1 *.sh | tr '\n' ' ')

#echo $ALL_SHELL_SCRIPTS

cd $ORG_PWD
unset ORG_PWD

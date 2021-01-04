# - Try to find LibUPnP (pupnp) 1.12
# Once done this will define
#  UPNP_FOUND - System has LibUPnP
#  UPNP_INCLUDE_DIRS - The LibUPnP include directories
#  UPNP_LIBRARIES - The libraries needed to use LibUPnP
#  UPNP_VERSION_STRING - The version of LinUPnP found
#  UPNP_HAS_IPV6 - If LinUPnP was built with IPv6 support
#  UPNP_HAS_REUSEADDR - If LinUPnP was built with SO_REUSEADDR support
include(CheckCXXSymbolExists)

find_package(PkgConfig QUIET)
pkg_search_module (PC_UPNP QUIET libupnp)

find_path(UPNP_INCLUDE_DIR upnp.h
    HINTS ${PC_UPNP_INCLUDEDIR} ${PC_UPNP_INCLUDE_DIRS}
    PATH_SUFFIXES upnp)

find_library(UPNP_UPNP_LIBRARY
    NAMES libupnp upnp
    HINTS ${PC_UPNP_LIBDIR} ${PC_UPNP_LIBRARY_DIRS})

find_library(UPNP_IXML_LIBRARY
    NAMES libixml ixml
    HINTS ${PC_UPNP_LIBDIR} ${PC_UPNP_LIBRARY_DIRS})

if(EXISTS ${UPNP_INCLUDE_DIR}/upnpconfig.h)
    file (STRINGS ${UPNP_INCLUDE_DIR}/upnpconfig.h _UPNP_DEFS REGEX "^[ \t]*#define[ \t]+UPNP_VERSION_(MAJOR|MINOR|PATCH)")
    string (REGEX REPLACE ".*UPNP_VERSION_MAJOR ([0-9]+).*" "\\1" UPNP_MAJOR_VERSION "${_UPNP_DEFS}")
    string (REGEX REPLACE ".*UPNP_VERSION_MINOR ([0-9]+).*" "\\1" UPNP_MINOR_VERSION "${_UPNP_DEFS}")
    string (REGEX REPLACE ".*UPNP_VERSION_PATCH ([0-9]+).*" "\\1" UPNP_PATCH_VERSION "${_UPNP_DEFS}")
    set (pupnp_VERSION "${UPNP_MAJOR_VERSION}.${UPNP_MINOR_VERSION}.${UPNP_PATCH_VERSION}")

    check_cxx_symbol_exists(UPNP_ENABLE_IPV6 "${UPNP_INCLUDE_DIR}/upnpconfig.h" UPNP_HAS_IPV6)
    check_cxx_symbol_exists(UPNP_MINISERVER_REUSEADDR "${UPNP_INCLUDE_DIR}/upnpconfig.h" UPNP_HAS_REUSEADDR)
endif()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(pupnp
    REQUIRED_VARS UPNP_UPNP_LIBRARY UPNP_INCLUDE_DIR
    VERSION_VAR pupnp_VERSION)

if (pupnp_FOUND)
    if(NOT TARGET pupnp::pupnp)
        add_library(pupnp::pupnp SHARED IMPORTED)
        set_target_properties(pupnp::pupnp PROPERTIES
                IMPORTED_LOCATION ${UPNP_UPNP_LIBRARY}
                INTERFACE_INCLUDE_DIRECTORIES ${UPNP_INCLUDE_DIR}
                INTERFACE_LINK_LIBRARIES ${UPNP_IXML_LIBRARY}
                UPNP_ENABLE_IPV6 ${UPNP_HAS_IPV6}
                UPNP_MINISERVER_REUSEADDR ${UPNP_HAS_REUSEADDR}
        )

    endif()
endif ()

MARK_AS_ADVANCED(
    UPNP_INCLUDE_DIR
    UPNP_IXML_LIBRARY
    UPNP_UPNP_LIBRARY
)

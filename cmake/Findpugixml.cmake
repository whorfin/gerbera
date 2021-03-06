# - Try to find libpugixml
# Once done this will define
#
#  PUGIXML_FOUND - system has libpugixml
#  pugixml_INCLUDE_DIRS - the libpugixml include directory
#  pugixml_LIBRARIES - Link these to use PUGIXML
#

INCLUDE(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)

pkg_check_modules(PC_PUGIXML QUIET libpugixml)
find_path(PUGIXML_INCLUDE_DIR pugixml.hpp
    HINTS ${PC_PUGIXML_INCLUDEDIR} ${PC_PUGIXML_INCLUDE_DIRS})
FIND_LIBRARY(PUGIXML_LIBRARY pugixml
    HINTS ${PC_PUGIXML_LIBDIR} ${PC_PUGIXML_LIBRARY_DIRS})

FIND_PACKAGE_HANDLE_STANDARD_ARGS(pugixml
    REQUIRED_VARS PUGIXML_LIBRARY PUGIXML_INCLUDE_DIR)

if (PUGIXML_FOUND)
    set (pugixml_LIBRARIES ${PUGIXML_LIBRARY} ${PC_PUGIXML_LIBRARIES})
    set (pugixml_INCLUDE_DIRS ${PUGIXML_INCLUDE_DIR} )

    if(NOT TARGET pugixml::pugixml)
        add_library(pugixml::pugixml INTERFACE IMPORTED)
        set_target_properties(pugixml::pugixml PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${pugixml_INCLUDE_DIRS}")
        set_property(TARGET pugixml::pugixml PROPERTY INTERFACE_LINK_LIBRARIES "${pugixml_LIBRARIES}")
    endif()
endif ()

MARK_AS_ADVANCED(
    PUGIXML_INCLUDE_DIR
    PUGIXML_LIBRARY
)

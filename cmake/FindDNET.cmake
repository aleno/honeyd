###################################################################
# - Find the Dumb (not so!) Library: dnet
# Find the DNET includes and library
# http://code.google.com/p/libdnet/
#
# The environment variable DNETDIR allows to specficy where to find 
# libdnet in non standard location.
#  
#  DNET_INCLUDE_DIRS - where to find dnet.h, etc.
#  DNET_LIBRARIES   - List of libraries when using dnet.
#  DNET_FOUND       - True if dnet found.


IF(EXISTS $ENV{DNETDIR})
  FIND_PATH(DNET_INCLUDE_DIR 
    NAMES
    dnet.h
    dnet/ip.h
    dnet/tcp.h
    dnet/udp.h
    PATHS
      $ENV{DNETDIR}
    NO_DEFAULT_PATH
  )
  
  FIND_LIBRARY(DNET_LIBRARY
    NAMES 
      dnet
    PATHS
      $ENV{DNETDIR}
    NO_DEFAULT_PATH
  )

# Because DEBIAN _is_ specific :(  
  FIND_PATH(DNET_INCLUDE_DIR 
    NAMES
    dumbnet.h
    dumbnet/ip.h
    dumbnet/tcp.h
    dumbnet/udp.h
    PATHS
      $ENV{DNETDIR}
    NO_DEFAULT_PATH
  )
  IF(EXISTS $ENV{DNET_INCLUDE_DIR}/dumbnet.h)
    SET(OS_DEBIAN "YES")
  ENDIF(EXISTS $ENV{DNET_INCLUDE_DIR}/dumbnet.h)
  
  FIND_LIBRARY(DNET_LIBRARY
    NAMES 
      dumbnet
    PATHS
      $ENV{DNETDIR}
    NO_DEFAULT_PATH
  )

ELSE(EXISTS $ENV{DNETDIR})
  FIND_PATH(DNET_INCLUDE_DIR 
    NAMES
    dnet.h
    dnet/ip.h
    dnet/tcp.h
    dnet/udp.h
  )
  
  FIND_LIBRARY(DNET_LIBRARY
    NAMES 
      dnet
  )

# Because DEBIAN _is_ specific :(  
  FIND_PATH(DNET_INCLUDE_DIR 
    NAMES
    dumbnet.h
    dumbnet/ip.h
    dumbnet/tcp.h
    dumbnet/udp.h
  )
  IF(EXISTS $ENV{DNET_INCLUDE_DIR}/dumbnet.h)
    SET(OS_DEBIAN "YES")
  ENDIF(EXISTS $ENV{DNET_INCLUDE_DIR}/dumbnet.h)
  
  FIND_LIBRARY(DNET_LIBRARY
    NAMES 
      dumbnet
  )
  
ENDIF(EXISTS $ENV{DNETDIR})

SET(DNET_INCLUDE_DIRS ${DNET_INCLUDE_DIR})
SET(DNET_LIBRARIES ${DNET_LIBRARY})

IF(DNET_INCLUDE_DIRS)
  MESSAGE(STATUS "dnet include dirs set to ${DNET_INCLUDE_DIRS}")
ELSE(DNET_INCLUDE_DIRS)
  MESSAGE(FATAL " dnet include dirs cannot be found")
ENDIF(DNET_INCLUDE_DIRS)

IF(DNET_LIBRARIES)
  MESSAGE(STATUS "dnet library set to  ${DNET_LIBRARIES}")
ELSE(DNET_LIBRARIES)
  MESSAGE(FATAL "dnet library cannot be found")
ENDIF(DNET_LIBRARIES)

IF(OS_DEBIAN)
  MESSAGE(STATUS "dnet is dumbnet")
  SET(HAVE_DUMBNET 1)
ENDIF(OS_DEBIAN)

#Functions
INCLUDE(CheckFunctionExists)
SET(CMAKE_REQUIRED_INCLUDES ${DNET_INCLUDE_DIRS})
SET(CMAKE_REQUIRED_LIBRARIES ${DNET_LIBRARIES})
CHECK_FUNCTION_EXISTS("ip_checksum" HAVE_DNET_IPCHECKSUM)
CHECK_FUNCTION_EXISTS("ip_ntoa" HAVE_DNET_IP_NTOA)

CHECK_INCLUDE_FILES("dnet.h" HAVE_DNET_H)
CHECK_INCLUDE_FILES("dumbnet.h" HAVE_DUMBNET_H)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(DNET DEFAULT_MSG DNET_INCLUDE_DIRS DNET_LIBRARIES)

MARK_AS_ADVANCED(
  DNET_LIBRARIES
  DNET_INCLUDE_DIRS
  HAVE_DUMBNET
)

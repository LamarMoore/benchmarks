// Mantid Repository : https://github.com/mantidproject/mantid
//
// Copyright &copy; 2018 ISIS Rutherford Appleton Laboratory UKRI,
//   NScD Oak Ridge National Laboratory, European Spallation Source,
//   Institut Laue - Langevin & CSNS, Institute of High Energy Physics, CAS
// SPDX - License - Identifier: GPL - 3.0 +
#pragma once

#include <cxxtest/TestSuite.h>

//
// The [E]TSM_ macros can be used to print a specified message
// instead of the default one.
// This is useful when you refactor your tests, as shown below
//

class MessageTest : public CxxTest::TestSuite
{
public:
    void testValues()
    {
        checkValue( 0, "My hovercraft" );
        checkValue( 1, "is full" );
        checkValue( 2, "of eels" );
    }

    void checkValue( unsigned value, const char *message )
    {
        TSM_ASSERT( message, value != 0 );
        TSM_ASSERT_EQUALS( message, value, value * value );
    }
};

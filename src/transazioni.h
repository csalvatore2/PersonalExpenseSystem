#pragma once
#include <iostream>
#include <sqlite3.h>
#include "util.h"

namespace transazioni {
    void open(sqlite3* db);
}
#include "hello_world.h"

crow::response hello_world() {
    return crow::response(200, "Hello World!");
}

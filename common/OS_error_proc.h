/* Copyright 2000 Kjetil S. Matheussen

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. */

#pragma once


// why doesn't LANGSPEC work here?
extern LANGSPEC int SYSTEM_show_error_message(const char *message); // Used before and after Qt is running

#if __cplusplus
extern int SYSTEM_show_message_menu(const struct vector_t_ *options, const char *message, int ms_timeout = 20000); // Used when it's not safe, or possible, to run qt exec. Note that it might return -1.
#endif

extern LANGSPEC bool Error_init(void);

extern LANGSPEC void RError_internal(const char *fmt,...) FORMAT_ATTRIBUTE(1,2);
extern LANGSPEC void RWarning_internal(const char *fmt,...) FORMAT_ATTRIBUTE(1,2);
extern LANGSPEC void RWarning_not_prod_internal(const char *fmt,...) FORMAT_ATTRIBUTE(1,2);
extern LANGSPEC void Error_uninit(void);

// Add "printf" calls to make the C compiler show warning/error if using wrong arguments for FMT.
#define RError(...) do{donothing(0 && printf(__VA_ARGS__)); RError_internal(__VA_ARGS__);}while(0)
#define RWarning(...) do{donothing(0 && printf(__VA_ARGS__)); RWarning_internal(__VA_ARGS__);}while(0)
#define RWarning_not_prod(...) do{donothing(0 && printf(__VA_ARGS__)); RWarning_not_prodinternal(__VA_ARGS__);}while(0)


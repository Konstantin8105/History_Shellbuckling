/*
 * Copyright 28 May 1996 Sun Microsystems, Inc. All Rights Reserved
 */

#ifndef _MSGTXT_H 
#define _MSGTXT_H 

/* This file was created automatically from the error description file.
 * Do not edit this file, edit the error description file.
 *   /home/omazur/olg_lang/f77/fpp/src/fpp_msg.txt
 */

#include <stddef.h>

struct I18N_msg_t {
    const unsigned int severity;
    const int          catsetno;
    const int          catmsgno;
    const char * tag;
    const char * txt;
    const char * help_tag;
};

static const struct I18N_msg_t I18N_msg[] = {
    { 0, 1,   0, "MESSAGENOZEROISNOTUSED",
                 "Error: Message number 0 used",
                 NULL },
    { 0, 1,   1, "MSG_LINE",
                 "line" ,
                 NULL },
    { 0, 1,   2, "MSG_FATAL",
                 "fatal" ,
                 NULL },
    { 0, 1,   3, "MSG_ERROR",
                 "error" ,
                 NULL },
    { 0, 1,   4, "MSG_WARNING",
                 "warning" ,
                 NULL },
    { 0, 1,   5, "MSG_PDVER",
                 "%s: %s %s\n" ,
                 NULL },
    { 1, 1, 100, "WARN_DUBL",
                 "macro redefined: %s\n" ,
                 NULL },
    { 1, 1, 101, "WARN_DUBL1",
                 "keyword redefined: %s\n" ,
                 NULL },
    { 1, 1, 102, "WARN_MREC",
                 "macro recursion: %s\n" ,
                 NULL },
    { 1, 1, 103, "WARN_PINSUB",
                 "possibly incorrect substitution of macro %s\n" ,
                 NULL },
    { 1, 1, 104, "WARN_BADOPT",
                 "bad option: %s , ignored.\n" ,
                 NULL },
    { 1, 1, 105, "WARN_PIOP",
                 "possibly incorrect operator identifying: %s\n" ,
                 NULL },
    { 1, 1, 106, "WARN_IMPL",
                 "ambiguous usage of \"%s\", macro hasn't been substituted\n" ,
                 NULL },
    { 1, 1, 107, "WARN_FORMAT",
                 "ambiguous usage of \"%s\", macro hasn't been substituted\n" ,
                 NULL },
    { 1, 1, 108, "WARN_FPP_EXPR",
                 "fpp: division by 0 \n" ,
                 NULL },
    { 2, 1, 200, "ERR_FPP",
                 "unknown fpp directive.\n" ,
                 NULL },
    { 2, 1, 201, "ERR_BADS",
                 "bad syntax in %s\n" ,
                 NULL },
    { 2, 1, 202, "ERR_NOIF",
                 "#endif without #if.\n" ,
                 NULL },
    { 2, 1, 203, "ERR_NOIF1",
                 "#else without #if.\n" ,
                 NULL },
    { 2, 1, 204, "ERR_NOIF2",
                 "#elif without #if.\n" ,
                 NULL },
    { 2, 1, 205, "ERR_ELSE",
                 "too many #else's.\n" ,
                 NULL },
    { 2, 1, 206, "ERR_ELSE1",
                 "#elif after #else.\n" ,
                 NULL },
    { 2, 1, 207, "ERR_BADNAM",
                 "bad macro name.\n" ,
                 NULL },
    { 2, 1, 208, "ERR_IF",
                 "#if: %s.\n" ,
                 NULL },
    { 2, 1, 209, "ERR_LONG",
                 "macro too long.\n" ,
                 NULL },
    { 2, 1, 210, "ERR_NOEND",
                 "#if at line %d has no matching #endif.\n" ,
                 NULL },
    { 2, 1, 211, "ERR_NOPAR",
                 "macro must have arguments.\n" ,
                 NULL },
    { 2, 1, 212, "ERR_LONG1",
                 "actual arguments too long.\n" ,
                 NULL },
    { 2, 1, 213, "ERR_NOMATCH",
                 "number of arguments doesn't match.\n" ,
                 NULL },
    { 2, 1, 214, "ERR_LONG2",
                 "incomplete macro call %s.\n" ,
                 NULL },
    { 2, 1, 215, "ERR_NOINC",
                 "can't find include file: %s\n" ,
                 NULL },
    { 2, 1, 216, "ERR_STR",
                 "missing %c.\n" ,
                 NULL },
    { 2, 1, 217, "ERR_LCOMM",
                 "comment doesn't end to the end of file.\n" ,
                 NULL },
    { 2, 1, 218, "ERR_HRTH",
                 "bad hollerith constant.\n" ,
                 NULL },
    { 2, 1, 219, "ERR_LONGLBL",
                 "label too long.\n" ,
                 NULL },
    { 2, 1, 220, "ERR_MREC",
                 "macro recursion: %s\n" ,
                 NULL },
    { 3, 1, 300, "FERR_CHCK",
                 "check got false in file %s line %d.\n" ,
                 NULL },
    { 3, 1, 301, "FERR_NOMEM",
                 "out of memory.\n" ,
                 NULL },
    { 3, 1, 302, "FERR_ARGS",
                 "Usage:\tfpp [-flags]... [filein [fileout]]\n" ,
                 NULL },
    { 3, 1, 303, "FERR_FOPEN",
                 "can't fopen file: %s\n" ,
                 NULL },
    { 3, 1, 304, "FERR_FREAD",
                 "can't fgets from file: %s\n" ,
                 NULL },
    { 3, 1, 305, "FERR_FWRITE",
                 "can't fwrite to file: %s\n" ,
                 NULL },
    { 3, 1, 306, "FERR_MWOFN",
                 "no input file specified with -M option\n" ,
                 NULL },
    { 3, 1, 307, "FERR_NOWDIR",
                 "unable to find current directory\n" ,
                 NULL }
};

#endif /* _MSGTXT_H */
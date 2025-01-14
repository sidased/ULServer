// SMsg_GS_Login.cpp  -*- C++ -*-
// $Id: SMsg_GS_Login.cpp,v 1.1 1997-08-13 15:39:04-07 jason Exp $
// Copyright 1996-1997 Lyra LLC, All rights reserved.
//
// message implementation

#ifdef __GNUC__
#pragma implementation "SMsg_GS_Login.h"
#endif

#ifdef WIN32
#define STRICT
#include "unix.h"
#include <winsock.h>
#else /* !WIN32 */
#include <sys/types.h>
#include <netinet/in.h>
#endif /* WIN32 */
#include <stdio.h>
#include <string.h>

#include "SMsg_GS_Login.h"
#include "LyraDefs.h"
#include "SMsg.h"

#ifndef USE_INLINE
#include "SMsg_GS_Login.i"
#endif

////
// constructor
////

SMsg_GS_Login::SMsg_GS_Login()
  : LmMesg(SMsg::GS_LOGIN, sizeof(data_t), sizeof(data_t), &data_)
{
  // initialize default message data values
  Init(Lyra::ID_UNKNOWN);
}

////
// destructor
////

SMsg_GS_Login::~SMsg_GS_Login()
{
  // empty
}

////
// Init
////

void SMsg_GS_Login::Init(lyra_id_t playerid)
{
  SetPlayerID(playerid);
}

////
// hton
////

void SMsg_GS_Login::hton()
{
  // internal message - not used
}

////
// ntoh
////

void SMsg_GS_Login::ntoh()
{
  // internal message - not used
}

////
// Dump: print to FILE stream
////

void SMsg_GS_Login::Dump(FILE* f, int indent) const
{
  INDENT(indent, f);
 _ftprintf(f, _T("<SMsg_GS_Login[%p,%d]: "), this, sizeof(SMsg_GS_Login));
  if (ByteOrder() == ByteOrder::HOST) {
   _ftprintf(f, _T("playerid=%u>\n"), PlayerID());
  }
  else {
   _ftprintf(f, _T("(network order)>\n"));
  }
  // print out base class
  LmMesg::Dump(f, indent + 1);
}

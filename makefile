# Copyright 2008
# Makefile for C program 
# Changed to support PRO*C

EXE=nome_do_programa

OBJ=$(EXE).o
SRC=$(EXE).c
PRO=$(EXE).pc
INC=$(EXE).h

.SUFFIXES: .h .pc .c .o

$(EXE):  $(OBJ)
#	 $(CC) -o $(EXE) $(OBJ) $(PROLDLIBS) $(LDFLAGS) $(LIBS)
	 $(CC) -o $(EXE) $(OBJ) $(PROLDLIBS) $(LDFLAGS) -ll $(LIBS)

$(OBJ):  $(SRC)
	 $(CC) $(CFLAGS) -c $*.c

$(SRC):  $(PRO) $(INC)
	 $(PROC) $(PROCPLSFLAGS) iname=$*

#
# The macro definition fill in some details or override some defaults from
# other files.
#
include $(ORACLE_HOME)/precomp/lib/env_precomp.mk
OTTFLAGS=$(PCCFLAGS)
CLIBS= $(TTLIBS_QA) $(LDLIBS)
MAKEFILE=$(ORACLE_HOME)/precomp/demo/proc/demo_proc.mk
PROCPLSFLAGS= SQLCHECK=full USERID=$(USERID)
PROCPPFLAGS= code=cpp $(CCPSYSINCLUDE)
USERID=usuario_bd/senha_bd@NOME_BD
NETWORKHOME=$(ORACLE_HOME)/network/
PLSQLHOME=$(ORACLE_HOME)/plsql/
INCLUDE=$(I_SYM). $(I_SYM)$(PRECOMPHOME)public $(I_SYM)$(RDBMSHOME)public $(I_SYM)$(RDBMSHOME)demo $(I_SYM)$(PLSQLHOME)public $(I_SYM)$(NETWORKHOME)public
I_SYM=-I
STATICPROLDLIBS=$(SCOREPT) $(SSCOREED) $(DEF_ON) $(LLIBCLIENT) $(LLIBSQL) $(STATICTTLIBS)
PROLDLIBS=$(LLIBCLNTSH) $(STATICPROLDLIBS)
LDFLAGS =  -L$(ORACLE_HOME)/lib $(EXTRA_LDIR) 
LIBS = $(PC_LIBS) $(SYS_LIBS) $(EXTRA_LIBS)
OPTIMIZE = -g

PCFLAGS=-xO2 -xstrconst -xF  -mr  -xarch=v8 -xcache=16/32/1:1024/64/1 -xchip=ultra -K PIC
PCDEFS=-D_REENTRANT -DSLMXMX_ENABLE -DSLTS_ENABLE -D_SVID_GETTOD
PROC_FLAGS=$(PCFLAGS) $(PCDEFS)
PC_INCL=-I$(ORACLE_HOME)/precomp/public -I$(ORACLE_HOME)/rdbms/public -I$(ORACLE_HOME)/plsql/public -I$(ORACLE_HOME)/network/public
CFLAGS = $(PROC_FLAGS) $(PC_INCL)

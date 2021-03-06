parser grammar Decaf;

options {
    tokenVocab=SDecaf;
}

@parser::header{
  package compiler.parser;
}


start: (callout_decl)* (field_decl)* (method_decl)*     										    #inicio ;

callout_decl: KW_CALLOUT ID PYC     														                #calloutDecl ;

method_decl: (type|KW_VOID) ID PA (type ID (COMMA type ID)*)?  PC  block        #methodDecl ;
type:  (KW_INT | KW_BOOLEAN)          ;

field_decl: type (arr | ID)  (COMMA (ID | arr)?)* PYC                           #fieldDecl ; 
arr: ID (LSBRACKET (INT | HEX) RSBRACKET);

statement: 
   location assign_opp expr PYC                                             #statement1 //Clase Asignation
  | method_call PYC                                                         #statement2 //Clase Pnode
  | KW_IF PA expr PC block (KW_ELSE block)?                                 #statement3 //Clase IfStatement
  | KW_FOR PA ID IG expr COMMA expr PC block                                #statement4 //Clase ForStatement
  | KW_WHILE PA expr PC block                                               #statement5 //Clase WhileStatement
  | KW_RETURN (expr)? PYC                                                   #statement6 //Clase ReturnStatement
  | KW_BREAK PYC                                                            #statement7 //Clase Terminal
  |  KW_CONTINUE PYC                                                        #statement8 //Clase Terminal
  ;


block: LCBRACKET (field_decl)* (statement)* RCBRACKET    										 #blocke ;
 

location: (ID | ID LSBRACKET expr RSBRACKET)                                 #loc;

expr:             																		                 
   location               																		                  
  | method_call          																		                  
  | literal                        																              
  | bin_op        																		               
   ;               

bin_op:
    RES bin_op             																		               #bin1
  | NO bin_op           																	                   #bin2
  | bin_op (MULT|DIV|PRCNT) bin_op             															 #bin3		
  | bin_op (PLUS|RES) bin_op             																		 #bin4
  | bin_op (MENOR|MAYOR|MENORIGUAL|MAYORIGUAL) bin_op             					 #bin5											
  | bin_op (DIG|NOIGUAL) bin_op                                              #bin6
  | bin_op AND bin_op                                                        #bin7
  | bin_op OR bin_op            																	           #bin8
  | expr2                                                                    #bin9
  | PA bin_op PC                                                             #bin10
   ;

expr2:
    location                                                                
  | method_call                                                             
  | literal
  ;
assign_opp: (IG|PLUS_IG|MIN_IG)										                         #assignOp;

method_call: ID PA (method_call_expr | method_call_callout)? PC          #methodcall;

method_call_expr: expr (COMMA expr)*;
method_call_callout: callout_arg (COMMA callout_arg)*;


callout_arg: 
	   expr                                             			                  #calloutArg1
   | STRING             																		                  #calloutArg2
    ;

literal: 
     int_literal            																	                #literal1
   | char_literal            																	                #literal2
   | bool_literal            																	                #literal3
   ;

int_literal: (INT | HEX)                                                      #literalInt ;

char_literal: CHAR              																              #literalChar ;

bool_literal: (BOOL_TRUE | BOOL_FALSE)             								            #literalBoolean ;
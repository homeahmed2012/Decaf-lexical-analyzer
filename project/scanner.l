/* File:  scanner.l
 * ----------------
 * Lex input file to generate the scanner for the compiler.
 */

%{

/* The text within this first region delimited by %{ and %} is assumed to
 * be C/C++ code and will be copied verbatim to the lex.yy.c file ahead
 * of the definitions of the yylex() function. Add other header file inclusions
 * or C++ variable declarations/prototypes that are needed by your code here.
 */

#include <string.h>
#include "scanner.h"
#include "utility.h" // for PrintDebug()
#include "errors.h"

/* Global variable: yylval
 * -----------------------
 * This global variable is how we get attribute information about the token
 * just scanned to the client. The scanner sets the global variable
 * appropriately and since it's global the client can just read it.  In the
 * future, this variable will be declared for us in the y.tab.c file
 * produced by Yacc, but for now, we declare it manually.
 */
YYSTYPE yylval;  // manually declared for pp1, later Yacc provides

/* Global variable: yylloc
 * -----------------------
 * This global variable is how we get position information about the token
 * just scanned to the client. (Operates similarly to yylval above)
 */
struct yyltype yylloc; // manually dclared for pp1, later Yacc provides

/* Macro: YY_USER_ACTION 
 * ---------------------
 * This flex built-in macro can be defined to provide an action which is
 * always executed prior to any matched rule's action. Basically, it is
 * a way of having a piece of code common to all actions factored out to
 * this routine.  We already defined it for you and left the empty
 * function DoBeforeEachAction ready for your use as needed. It will
 * be called once for each pattern scanned from the file, before
 * executing its action.
 */
static void DoBeforeEachAction(); 
#define YY_USER_ACTION DoBeforeEachAction();
int yycolumn = 1;
%}

%option yylineno
 /* The section before the first %% is the Definitions section of the lex
  * input file. Here is where you set options for the scanner, define lex
  * states, and can set up definitions to give names to regular expressions
  * as a simple substitution mechanism that allows for more readable
  * entries in the Rules section later. 
  */


%%             /* BEGIN RULES SECTION */
 /* All patterns and actions should be placed between the start and stop
  * %% markers which delimit the Rules section. 
  */ 

"boolean"       {return 259;}
"break"         {return 275;}
"class"         {return 261;}
"else"          {return 273;}
"extends"       {return 276;}
"false"         {yylval.boolConstant = false; 
                 return 286;}
"float"         {return 258;}
"for"           {return 271;}
"if"            {return 272;}
"int"           {return 257;}
"new"           {return 280;}
"null"          {return 262;}
"return"        {return 274;}
"this"          {return 277;}
"true"          {yylval.boolConstant = true; 
                 return 286;}
"void"          {return 256;}
"while"         {return 270;}
"String"        {return 260;}
"<="            {return 264;}
">="            {return 265;}
"=="            {return 266;} 
"!="            {return 267;}
"&&"            {return 268;}
"\|\|"          {return 269;}
"{"|"}"|"["|"]"|"("|")"|"."|"+"|"-"|"/"|"="|"!"|"*"         {return yytext[0];}
[_a-zA-Z][_a-zA-Z0-9]*   {strncpy(yylval.identifier, yytext, 31);
                          if(strlen(yytext) > 31)
                            ReportError::LongIdentifier(&yylloc, yytext);
                          yylval.identifier[31]=0;
                          return 282;} 
\"[^\"\n]*\"  { yylval.stringConstant = yytext;
                return 283;}
\"[^\"]*\n    { ReportError::UntermString(&yylloc, yytext);
                yycolumn = 1;}            
[0-9]+        {yylval.integerConstant = atoi(yytext);
               return 284;}
[-\+]?[0-9]+\.[0-9]+([eE][-\+]?[0-9]+)? {yylval.doubleConstant = strtod(yytext, NULL);
                                         return 285;}
(("[^"]*){2})*(\/\/.*)   {;}
"/*"([^*]|\*+[^*/])*\*+"/"           {;}
[ \t]         {;}
\n            {yycolumn = 1;}
.             {ReportError::UnrecogChar(&yylloc, yytext[0]);}
%%
/* The closing %% above marks the end of the Rules section and the beginning
 * of the User Subroutines section. All text from here to the end of the
 * file is copied verbatim to the end of the generated lex.yy.c file.
 * This section is where you put definitions of helper functions.
 */


/* Function: InitScanner
 * ---------------------
 * This function will be called before any calls to yylex().  It is designed
 * to give you an opportunity to do anything that must be done to initialize
 * the scanner (set global variables, configure starting state, etc.). One
 * thing it already does for you is assign the value of the global variable
 * yy_flex_debug that controls whether flex prints debugging information
 * about each token and what rule was matched. If set to false, no information
 * is printed. Setting it to true will give you a running trail that might
 * be helpful when debugging your scanner. Please be sure the variable is
 * set to false when submitting your final version.
 */
void InitScanner()
{
    PrintDebug("lex", "Initializing scanner");
    yy_flex_debug = false;
}


/* Function: DoBeforeEachAction()
 * ------------------------------
 * This function is installed as the YY_USER_ACTION. This is a place
 * to group code common to all actions.
 */
static void DoBeforeEachAction()
{
  yylloc.first_line = yylloc.last_line = yylineno;
  yylloc.first_column = yycolumn; 
  yylloc.last_column = yycolumn + yyleng - 1;
  yycolumn += yyleng;
}

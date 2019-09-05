%skeleton "lalr1.cc"
%require "3.4.1"
%defines

%define api.token.constructor
%define api.value.type variant
%define parse.assert
%output "sqlite3_parser.cpp"
%define api.location.file "sqlite3_location.h"
%define api.namespace { sqlb::parser }

%code requires {
	#include <string>
	#include "../sqlitetypes.h"
	#include "../ObjectIdentifier.h"
	namespace sqlb { namespace parser { class ParserDriver; } }
	typedef void* yyscan_t;
}

// The parsing context
%param { yyscan_t yyscanner }
%param { ParserDriver& drv }

%locations

%define parse.trace
%define parse.error verbose

%code {
	#include "ParserDriver.h"
}

%define api.token.prefix {TOK_}
%token
	EOF		0  "end of file"
	LPAREN		"("
	RPAREN		")"
	DOT		"."
	COMMA		","
	SEMI		";"
	PLUS		"+"
	MINUS		"-"
	STAR		"*"
	SLASH		"/"
	TILDE		"~"
	AMPERSAND	"&"
	PERCENT		"%"
	BITOR		"|"
	OROP		"||"
	EQUAL		"="
	EQUAL2		"=="
	GREATER		">"
	GREATEREQUAL	">="
	LOWER		"<"
	LOWEREQUAL	"<="
	UNEQUAL		"!="
	UNEQUAL2	"<>"
	BITWISELEFT	"<<"
	BITWISERIGHT	">>"
;

%token <std::string> ABORT "ABORT"
%token <std::string> ACTION "ACTION"
%token <std::string> AND "AND"
%token <std::string> AS "AS"
%token <std::string> ASC "ASC"
%token <std::string> AUTOINCREMENT "AUTOINCREMENT"
%token <std::string> BETWEEN "BETWEEN"
%token <std::string> CASCADE "CASCADE"
%token <std::string> CASE "CASE"
%token <std::string> CAST "CAST"
%token <std::string> CHECK "CHECK"
%token <std::string> COLLATE "COLLATE"
%token <std::string> CONFLICT "CONFLICT"
%token <std::string> CONSTRAINT "CONSTRAINT"
%token <std::string> CREATE "CREATE"
%token <std::string> CURRENT_DATE "CURRENT_DATE"
%token <std::string> CURRENT_TIME "CURRENT_TIME"
%token <std::string> CURRENT_TIMESTAMP "CURRENT_TIMESTAMP"
%token <std::string> DEFAULT "DEFAULT"
%token <std::string> DEFERRABLE "DEFERRABLE"
%token <std::string> DEFERRED "DEFERRED"
%token <std::string> DELETE "DELETE"
%token <std::string> DESC "DESC"
%token <std::string> DISTINCT "DISTINCT"
%token <std::string> ELSE "ELSE"
%token <std::string> END "END"
%token <std::string> ESCAPE "ESCAPE"
%token <std::string> EXISTS "EXISTS"
%token <std::string> FAIL "FAIL"
%token <std::string> FALSE "FALSE"
%token <std::string> FILTER "FILTER"
%token <std::string> FOLLOWING "FOLLOWING"
%token <std::string> FOREIGN "FOREIGN"
%token <std::string> GLOB "GLOB"
%token <std::string> IF "IF"
%token <std::string> IGNORE "IGNORE"
%token <std::string> IMMEDIATE "IMMEDIATE"
%token <std::string> IN "IN"
%token <std::string> INDEX "INDEX"
%token <std::string> INITIALLY "INITIALLY"
%token <std::string> INSERT "INSERT"
%token <std::string> IS "IS"
%token <std::string> ISNULL "ISNULL"
%token <std::string> KEY "KEY"
%token <std::string> LIKE "LIKE"
%token <std::string> MATCH "MATCH"
%token <std::string> NO "NO"
%token <std::string> NOT "NOT"
%token <std::string> NOTNULL "NOTNULL"
%token <std::string> NULL "NULL"
%token <std::string> ON "ON"
%token <std::string> OR "OR"
%token <std::string> OVER "OVER"
%token <std::string> PARTITION "PARTITION"
%token <std::string> PRECEDING "PRECEDING"
%token <std::string> PRIMARY "PRIMARY"
%token <std::string> RAISE "RAISE"
%token <std::string> RANGE "RANGE"
%token <std::string> REFERENCES "REFERENCES"
%token <std::string> REGEXP "REGEXP"
%token <std::string> REPLACE "REPLACE"
%token <std::string> RESTRICT "RESTRICT"
%token <std::string> ROLLBACK "ROLLBACK"
%token <std::string> ROWID "ROWID"
%token <std::string> ROWS "ROWS"
%token <std::string> SELECT "SELECT"
%token <std::string> SET "SET"
%token <std::string> TABLE "TABLE"
%token <std::string> TEMP "TEMP"
%token <std::string> TEMPORARY "TEMPORARY"
%token <std::string> THEN "THEN"
%token <std::string> TRUE "TRUE"
%token <std::string> UNBOUNDED "UNBOUNDED"
%token <std::string> UNIQUE "UNIQUE"
%token <std::string> UPDATE "UPDATE"
%token <std::string> USING "USING"
%token <std::string> VIRTUAL "VIRTUAL"
%token <std::string> WHEN "WHEN"
%token <std::string> WHERE "WHERE"
%token <std::string> WITHOUT "WITHOUT"

%token <std::string> IDENTIFIER "identifier"
%token <std::string> NUMERIC "numeric"
%token <std::string> STRINGLITERAL "string literal"
%token <std::string> QUOTEDLITERAL "quoted literal"
%token <std::string> BLOBLITERAL "blob literal"
%token <std::string> BINDPARAMETER "bind parameter"

%type <std::string> literalvalue
%type <std::string> id
%type <std::string> tableid
%type <std::string> columnid
%type <std::string> typename_namelist
%type <std::string> type_name
%type <std::string> unary_expr
%type <std::string> binary_expr
%type <std::string> like_expr
%type <std::string> exprlist_expr
%type <std::string> function_expr
%type <std::string> isnull_expr
%type <std::string> between_expr
%type <std::string> in_expr
%type <std::string> whenthenlist_expr
%type <std::string> case_expr
%type <std::string> raise_expr
%type <std::string> expr
%type <bool> optional_if_not_exists
%type <bool> optional_unique
%type <std::string> optional_collate
%type <std::string> optional_sort_order
%type <std::string> optional_where
%type <std::string> tableid_with_uninteresting_schema
%type <std::string> select_stmt
%type <sqlb::IndexedColumn> indexed_column
%type <sqlb::IndexedColumnVector> indexed_column_list
%type <sqlb::IndexPtr> createindex_stmt

%%

%left OR;
%left AND;
%right NOT;
%left IS MATCH LIKE BETWEEN IN UNEQUAL UNEQUAL2 EQUAL EQUAL2 GLOB REGEXP ISNULL NOTNULL;
%left GREATER LOWEREQUAL LOWER GREATEREQUAL;
%right ESCAPE;
%left AMPERSAND BITOR BITWISELEFT BITWISERIGHT;
%left PLUS MINUS;
%left STAR SLASH PERCENT;
%left OROP;
%left COLLATE;
%right TILDE;
%nonassoc ON;

%start statement;
statement:
	createindex_stmt { drv.result = $1; }
	;

literalvalue:
	NUMERIC
	| STRINGLITERAL
	| BLOBLITERAL
	| NULL
	| TRUE
	| FALSE
	| CURRENT_TIME
	| CURRENT_DATE
	| CURRENT_TIMESTAMP
	;

id:
	IDENTIFIER
	| QUOTEDLITERAL
	/*| STRINGLITERAL*/
	;

tableid:
	ABORT
	| ACTION
	| ASC
	| CASCADE
	| CAST
	| CONFLICT
	| CURRENT_TIME
	| CURRENT_DATE
	| CURRENT_TIMESTAMP
	| DEFERRED
	| DESC
	| ELSE
	| END
	| FAIL
	| FILTER
	| FOLLOWING
	| GLOB
	| KEY
	| LIKE
	| IGNORE
	| INITIALLY
	| IMMEDIATE
	| MATCH
	| NO
	| OVER
	| PARTITION
	| PRECEDING
	| RAISE
	| RANGE
	| REGEXP
	| REPLACE
	| RESTRICT
	| ROLLBACK
	| ROWID
	| ROWS
	| TEMPORARY
	| TEMP
	| UNBOUNDED
	| VIRTUAL
	| WITHOUT
	| id
	;

columnid:
	ABORT
	| ACTION
	| ASC
	| CASCADE
	| CAST
	| CONFLICT
	| CURRENT_TIME
	| CURRENT_DATE
	| CURRENT_TIMESTAMP
	| DEFERRED
	| DESC
	| END
	| FAIL
	| FILTER
	| FOLLOWING
	| GLOB
	| KEY
	| LIKE
	| IF
	| IGNORE
	| INITIALLY
	| IMMEDIATE
	| MATCH
	| NO
	| OVER
	| PARTITION
	| PRECEDING
	| RAISE
	| RANGE
	| REGEXP
	| REPLACE
	| RESTRICT
	| ROLLBACK
	| ROWID
	| ROWS
	| TEMPORARY
	| TEMP
	| UNBOUNDED
	| VIRTUAL
	| WITHOUT
	| id
	;

typename_namelist:
	tableid					{ $$ = $1; }
	| typename_namelist " " tableid		{ $$ = $1 + " " + $3; }
	;

type_name:
	typename_namelist					{ $$ = $1; }
	| typename_namelist "(" NUMERIC ")"			{ $$ = $1 + "(" + $3 + ")"; }
	| typename_namelist "(" NUMERIC "," NUMERIC ")"		{ $$ = $1 + "(" + $3 + ", " + $5 + ")"; }
	;

unary_expr:
	"-" expr		{ $$ = "-" + $2; }
	| "+" expr		{ $$ = "+" + $2; }
	| "~" expr		{ $$ = "~" + $2; }
	| NOT expr		{ $$ = "NOT " + $2; }
	;

binary_expr:
	expr "||" expr		{ $$ = $1 + " || " + $3; }
	| expr "*" expr		{ $$ = $1 + " * " + $3; }
	| expr "/" expr		{ $$ = $1 + " / " + $3; }
	| expr "%" expr		{ $$ = $1 + " % " + $3; }
	| expr "+" expr		{ $$ = $1 + " + " + $3; }
	| expr "-" expr		{ $$ = $1 + " - " + $3; }
	| expr "<<" expr	{ $$ = $1 + " << " + $3; }
	| expr ">>" expr	{ $$ = $1 + " >> " + $3; }
	| expr "&" expr		{ $$ = $1 + " & " + $3; }
	| expr "|" expr		{ $$ = $1 + " | " + $3; }
	| expr "<" expr		{ $$ = $1 + " < " + $3; }
	| expr "<=" expr	{ $$ = $1 + " <= " + $3; }
	| expr ">" expr		{ $$ = $1 + " > " + $3; }
	| expr ">=" expr	{ $$ = $1 + " >= " + $3; }
	| expr "=" expr		{ $$ = $1 + " = " + $3; }
	| expr "==" expr	{ $$ = $1 + " == " + $3; }
	| expr "!=" expr	{ $$ = $1 + " != " + $3; }
	| expr "<>" expr	{ $$ = $1 + " <> " + $3; }
	| expr IS expr		{ $$ = $1 + " IS " + $3; }
	| expr AND expr		{ $$ = $1 + " AND " + $3; }
	| expr OR expr		{ $$ = $1 + " OR " + $3; }
	;

like_expr:
	expr LIKE expr				{ $$ = $1 + " LIKE " + $3; }
	| expr GLOB expr			{ $$ = $1 + " GLOB " + $3; }
	| expr MATCH expr			{ $$ = $1 + " MATCH " + $3; }
	| expr REGEXP expr			{ $$ = $1 + " REGEXP " + $3; }
	| expr NOT LIKE expr			{ $$ = $1 + " NOT LIKE " + $3; }
	| expr NOT GLOB expr			{ $$ = $1 + " NOT GLOB " + $3; }
	| expr NOT MATCH expr			{ $$ = $1 + " NOT MATCH " + $3; }
	| expr NOT REGEXP expr			{ $$ = $1 + " NOT REGEXP " + $3; }
	| expr LIKE expr ESCAPE expr		{ $$ = $1 + " LIKE " + $3 + " ESCAPE " + $5; }
	| expr GLOB expr ESCAPE expr		{ $$ = $1 + " GLOB " + $3 + " ESCAPE " + $5; }
	| expr MATCH expr ESCAPE expr		{ $$ = $1 + " MATCH " + $3 + " ESCAPE " + $5; }
	| expr REGEXP expr ESCAPE expr		{ $$ = $1 + " REGEXP " + $3 + " ESCAPE " + $5; }
	| expr NOT LIKE expr ESCAPE expr	{ $$ = $1 + " NOT LIKE " + $3 + " ESCAPE " + $6; }
	| expr NOT GLOB expr ESCAPE expr	{ $$ = $1 + " NOT GLOB " + $3 + " ESCAPE " + $6; }
	| expr NOT MATCH expr ESCAPE expr	{ $$ = $1 + " NOT MATCH " + $3 + " ESCAPE " + $6; }
	| expr NOT REGEXP expr ESCAPE expr	{ $$ = $1 + " NOT REGEXP " + $3 + " ESCAPE " + $6; }
	;

exprlist_expr:
	expr					{ $$ = $1; }
	| exprlist_expr "," expr		{ $$ = $1 + ", " + $3; }
	;

function_expr:
	id "(" exprlist_expr ")"		{ $$ = $1 + "(" + $3 + ")"; }
	| id "(" DISTINCT exprlist_expr ")"	{ $$ = $1 + "(DISTINCT " + $4 + ")"; }
	| id "(" ")"				{ $$ = $1 + "()"; }
	| id "(" "*" ")"			{ $$ = $1 + "(*)"; }
	;

isnull_expr:
	expr ISNULL				{ $$ = $1 + " ISNULL"; }
	| expr NOTNULL				{ $$ = $1 + " NOTNULL"; }
	| expr NOT NULL				{ $$ = $1 + " NOT NULL"; }
	;

between_expr:
	expr BETWEEN expr AND expr		{ $$ = $1 + " BETWEEN " + $3 + " AND " + $5; }		// TODO Solve reduce/reduce conflict for these two
	| expr NOT BETWEEN expr AND expr	{ $$ = $1 + " NOT BETWEEN " + $4 + " AND " + $6; }
	;

in_expr:
	expr IN "(" ")"					{ $$ = $1 + " IN ()"; }
	| expr IN "(" select_stmt ")"			{ $$ = $1 + " IN (" + $4 + ")"; }
	| expr IN "(" exprlist_expr ")"			{ $$ = $1 + " IN (" + $4 + ")"; }
	| expr IN id "." tableid			{ $$ = $1 + " IN " + sqlb::escapeIdentifier($3) + "." + sqlb::escapeIdentifier($5); }
	| expr IN tableid				{ $$ = $1 + " IN " + sqlb::escapeIdentifier($3); }
	| expr IN id "." id "(" ")"			{ $$ = $1 + " IN " + sqlb::escapeIdentifier($3) + "." + $5 + "()"; }
	| expr IN id "." id "(" exprlist_expr ")"	{ $$ = $1 + " IN " + sqlb::escapeIdentifier($3) + "." + $5 + "(" + $7 + ")"; }
	| expr IN id "(" exprlist_expr ")"		{ $$ = $1 + " IN " + $3 + "(" + $5 + ")"; }
	| expr NOT IN "(" ")"				{ $$ = $1 + " NOT IN ()"; }
	| expr NOT IN "(" select_stmt ")"		{ $$ = $1 + " NOT IN (" + $5 + ")"; }
	| expr NOT IN "(" exprlist_expr ")"		{ $$ = $1 + " NOT IN (" + $5 + ")"; }
	| expr NOT IN id "." tableid			{ $$ = $1 + " NOT IN " + sqlb::escapeIdentifier($4) + "." + sqlb::escapeIdentifier($6); }
	| expr NOT IN tableid				{ $$ = $1 + " NOT IN " + sqlb::escapeIdentifier($4); }
	| expr NOT IN id "." id "(" ")"			{ $$ = $1 + " NOT IN " + sqlb::escapeIdentifier($4) + "." + $6 + "()"; }
	| expr NOT IN id "." id "(" exprlist_expr ")"	{ $$ = $1 + " NOT IN " + sqlb::escapeIdentifier($4) + "." + $6 + "(" + $8 + ")"; }
	| expr NOT IN id "(" exprlist_expr ")"		{ $$ = $1 + " NOT IN " + $4 + "(" + $6 + ")"; }
	;

whenthenlist_expr:
	WHEN expr THEN expr				{ $$ = "WHEN " + $2 + " THEN " + $4; }
	| whenthenlist_expr WHEN expr THEN expr		{ $$ = $1 + " WHEN" + $3 + " THEN " + $5; }
	;

case_expr:
	CASE expr whenthenlist_expr ELSE expr END	{ $$ = "CASE " + $2 + " " + $3 + " ELSE " + $5 + " END"; }
	| CASE expr whenthenlist_expr END		{ $$ = "CASE " + $2 + " " + $3 + " END"; }
	| CASE whenthenlist_expr ELSE expr END		{ $$ = "CASE " + $2 + " ELSE " + $4 + " END"; }
	| CASE whenthenlist_expr END			{ $$ = "CASE " + $2 + " END"; }
	;

raise_expr:
	RAISE "(" IGNORE ")"				{ $$ = "RAISE(IGNORE)"; }
	| RAISE "(" ROLLBACK "," STRINGLITERAL ")"	{ $$ = "RAISE(ROLLBACK, " + $5 + ")"; }
	| RAISE "(" ABORT "," STRINGLITERAL ")"		{ $$ = "RAISE(ABORT, " + $5 + ")"; }
	| RAISE "(" FAIL "," STRINGLITERAL ")"		{ $$ = "RAISE(FAIL, " + $5 + ")"; }
	;

expr:
	literalvalue
	| BINDPARAMETER
	| id "." id "." id			{ $$ = sqlb::escapeIdentifier($1) + "." + sqlb::escapeIdentifier($3) + "." + sqlb::escapeIdentifier($5); }
	| id "." id				{ $$ = sqlb::escapeIdentifier($1) + "." + sqlb::escapeIdentifier($3); }
	| id					{ $$ = sqlb::escapeIdentifier($1); }
	| unary_expr
	| binary_expr
	| function_expr
	| "(" exprlist_expr ")"			{ $$ = "(" + $2 + ")"; }
	| CAST "(" expr AS type_name ")"	{ $$ = "CAST(" + $3 + " AS " + $5 + ")"; }
	| expr COLLATE id			{ $$ = $1 + " COLLATE " + $3; }
	| like_expr
	| isnull_expr
	| between_expr
	| in_expr
	| case_expr
	| raise_expr
	// TODO Window functions
	;

optional_if_not_exists:
	%empty					{ $$ = false; }
	| IF NOT EXISTS				{ $$ = true; }
	;

optional_unique:
	%empty					{ $$ = false; }
	| UNIQUE				{ $$ = true; }
	;

optional_where:
	%empty					{ $$ = ""; }
	| WHERE expr				{ $$ = $2; }
	;

optional_collate:
	%empty					{ $$ = ""; }
	| COLLATE id				{ $$ = $2; }
	;

optional_sort_order:
	%empty					{ $$ = ""; }
	| ASC					{ $$ = "ASC"; }
	| DESC					{ $$ = "DESC"; }
	;

tableid_with_uninteresting_schema:
	id "." tableid				{ $$ = $3; }
	| tableid				{ $$ = $1; }
	;

select_stmt:
	SELECT					{ $$ = "SELECT"; }		// TODO
	;

indexed_column:
	columnid optional_collate optional_sort_order	{ $$ = sqlb::IndexedColumn($1, false, $3, $2); }
	| expr optional_collate optional_sort_order	{ $$ = sqlb::IndexedColumn($1, true, $3, $2); }		// TODO Fix reduce/reduce warning
	;

indexed_column_list:
	indexed_column					{ $$ = sqlb::IndexedColumnVector(1, $1); }
	| indexed_column_list "," indexed_column	{ $$ = $1; $$.push_back($3); }
	;

createindex_stmt:
	CREATE optional_unique INDEX optional_if_not_exists tableid_with_uninteresting_schema ON tableid "(" indexed_column_list ")" optional_where		{
													$$ = sqlb::IndexPtr(new sqlb::Index($5));
													$$->setTable($7);
													$$->setUnique($2);
													$$->setWhereExpr($11);
													$$->fields = $9;
												}
	;

%%

void sqlb::parser::parser::error(const location_type& l, const std::string& m)
{
	std::cerr << l << ": " << m << '\n';
}

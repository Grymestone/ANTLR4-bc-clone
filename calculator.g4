grammar calculator; 

@header {
import java.util.*;
import java.lang.Math;
import java.util.Scanner;
}

@parser::members
{
/** "memory" for our calculator; variable/value pairs go here */
Map<String, Double> memory = new HashMap<String, Double>();

double eval(double l, int op, double r)
	{ switch(op) 
		{ case MULT: return l * r;
		case DIV: return l / r;
		case ADD: return l + r;
		case SUB: return l - r;
		}
	return 0;
	}
}

exprList: topExpr (';' topExpr)*';'?;

topExpr: printstat NEWLINE 
    |stat+ ;
  //{ System.out.println("result: "+ Integer.toString($expr.i));};

stat: 
    expr NEWLINE
    {
          System.out.println($expr.i);
    }
    | ID '=' expr NEWLINE
        {
	  String id = $ID.text;
          memory.put(id, $expr.i);
	}
    | NEWLINE
;

expr returns [double i]:
    '(' e=expr ')'
    {
    	$i = $e.i;
    }
    | er = expr op = (MULT | '/') el = expr 
    	{$i = eval($er.i, $op.type, $el.i);}
    | er = expr op = ('+' | '-') el = expr
    	{$i = eval($er.i, $op.type, $el.i);}
    | INT
        { $i=Integer.parseInt($INT.text);} 
    | ID
    	{ String id = $ID.text;
	$i = memory.containsKey(id) ? memory.get(id) : 0;
	}
    | 'sqrt(' e=expr ')' {
       $i = Math.sqrt($e.i); 
    }
    | 'read()' {
        Scanner reader = new Scanner(System.in);  // Reading from System.in
        double n = reader.nextDouble(); // Scans the next token of the input as an int.
        reader.close();
        $i = n;
    }
    | 's(' expr ')' {
        $i = Math.sin($expr.i);
    }
    | 'c(' expr ')' {
        $i = Math.cos($expr.i);
    }
    | 'l(' expr ')' {
        $i = Math.log($expr.i);
    }
    | 'e(' expr ')' {
        $i = Math.exp($expr.i);
    }
    ;

printstat : 'print' st=DQSTRING
    {
        String s = $st.text;
        s = s.substring(1, s.length()-1);
        s = s.replace("\"\"", "\"");
        System.out.println(s);
    };

ID: [_A-Za-z]+ ;
EQUAL: '=';
INT: [0-9]+ ;		      
MULT: '*' ;
SUB: '-';
DIV: '/';
ADD: '+';
NEWLINE:'\r'? '\n' ;
DQSTRING: '"' (~('"' | '\\' | '\r' | '\n') | '\\' ('"' | '\\'))* '"'; 
WS: [ \t]+ -> skip ;


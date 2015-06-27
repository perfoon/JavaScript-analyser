using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Activities;

using System.IO;
using Antlr.Runtime;
using Antlr.Runtime.Misc;
using Antlr.Runtime.Tree;
using System.Xml;
using System.Xml.XPath;
//using JavaScriptAnalyzer;

[assembly: CLSCompliant(false)]

namespace JavaScriptTranslatorActivities
{

    public sealed class JavaScriptParserActivity : CodeActivity
    {
        // Define an activity input argument of type string
        public InArgument<string> InputString { get; set; }
        public OutArgument<CommonTree> Ast { get; set; }

        protected override void Execute(CodeActivityContext context)
        {
            Console.WriteLine("ParserActivity - executed");
            string inputString = context.GetValue(this.InputString);


            ICharStream input;
            try
            {
                input = new ANTLRStringStream(inputString);
                JavaScriptLexer lexer = new JavaScriptLexer(input);
                CommonTokenStream tokens = new CommonTokenStream(lexer);
                JavaScriptParser parser = new JavaScriptParser(tokens);

                var parserResult = parser.program();

                if (parser.NumberOfSyntaxErrors > 0)
                {
                    Console.Out.WriteLine(parser.NumberOfSyntaxErrors + " syntax errors occured");
                }
                CommonTree ast = (CommonTree)parserResult.Tree;
                context.SetValue<CommonTree>(this.Ast, ast);

            }
            catch (FileNotFoundException e)
            {
                Console.Out.WriteLine("Can't find file:" + e.FileName);
                Environment.Exit(0);
            }
            catch (RecognitionException e)
            {
                Console.WriteLine("Recognition Exception: " + e.Source);
                Environment.Exit(0);
            }
            catch (RewriteEmptyStreamException e)
            {
                Console.WriteLine("Rewrite Empty Stream Exception: " + e.Message);
                Environment.Exit(0);
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Error when parsing AST: " + e.Message);
                Environment.Exit(0);
            }
        }
    }
}

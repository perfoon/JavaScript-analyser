using System;

using System.Text;
using System.Activities;

using System.IO;
using Antlr.Runtime;
using Antlr.Runtime.Misc;
using Antlr.Runtime.Tree;
//using JavaScriptAnalyzer;

namespace JavaScriptTranslatorActivities
{
    public sealed class AstPrinterActivity : CodeActivity
    {
        public InArgument<CommonTree> Ast { get; set; }

        protected override void Execute(CodeActivityContext context)
        {
            Console.WriteLine("PrinterActivity - executed");

            CommonTree ast = context.GetValue(this.Ast);
            this.PrintCommonTree(ast, "");
        }

        public void PrintCommonTree(CommonTree ast, string indent)
        {
            Console.WriteLine(indent + ast.ToString());// + "::" + ast.Token.GetHashCode().ToString());
            //Console.WriteLine(ast.GetType().Name);
            if (ast.Children != null)
            {
                indent += "  ";
                foreach (var child in ast.Children)
                {
                    var childTree = child as CommonTree;
                    //if (childTree.Text != EOF) 
                    {
                        PrintCommonTree(childTree, indent);
                    }
                }
            }
        }
    }
}

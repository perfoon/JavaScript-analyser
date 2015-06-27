using System;
using System.IO;
using Antlr.Runtime;
using Antlr.Runtime.Misc;
using Antlr.Runtime.Tree;
using System.Xml;
using System.Xml.XPath;
using System.Activities;
using System.Collections.Generic;

[assembly: CLSCompliant(false)] 

namespace JavaScriptAnalyzer
{
    class Program
    {
        static void Main(string[] args)
        {
            string filename = "";
            if (args.Length >= 1)
            {
                filename = args[0];
            }
            else
            {
                Console.Out.WriteLine("Command line argument with input filname is required!");
                Environment.Exit(0);
            }

            if (!Path.IsPathRooted(filename))
            {
                filename = Path.Combine(Environment.CurrentDirectory, filename);
            }

            string sourceCode = "";
            try
            {
                sourceCode = System.IO.File.ReadAllText(filename);
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Exeption while reading file: " + filename);
                Console.Out.WriteLine(e.Message);
                Environment.Exit(0);
            }

            var input = new Dictionary<string, object> ();
            input.Add("SourceCode", sourceCode);
            WorkflowInvoker invoke = new WorkflowInvoker(new JavaScriptAnalyzerActivity());

            Console.WriteLine("--JavaScript analyzer Workflow BEGIN--");

            invoke.Invoke(input);

            Console.WriteLine("--JavaScript analyzer Workflow END--");
        }

    }
}

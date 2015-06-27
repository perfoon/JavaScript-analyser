using System;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.Activities;


namespace JavaScriptAnalyzer
{

    public sealed class XmlAnalyzerActivity : CodeActivity
    {

        public InArgument<String> InputXmlName { get; set; }
        public InArgument<String> OutputXmlName { get; set; }

        private XslCompiledTransform transform;


        protected override void Execute(CodeActivityContext context)
        {
            transform = new XslCompiledTransform();

            String input = context.GetValue(this.InputXmlName);
            String output = context.GetValue(this.OutputXmlName);
            analyze(input, output);
            Console.Out.WriteLine(output);
        }

        public void analyze(String input, String output)
        {
            try
            {
                String filename = "styleMetrics.xslt";
                transform.Load(filename);
                transform.Transform(input, output);
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Error while analyzing xml: " + e.Message);
            }
        }

    }
}



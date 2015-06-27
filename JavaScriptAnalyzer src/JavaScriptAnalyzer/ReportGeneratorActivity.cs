using System;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.Activities;


namespace JavaScriptAnalyzer
{

    public sealed class ReportGeneratorActivity : CodeActivity
    {

        public InArgument<String> AnalysisResultsXmlName { get; set; }
        public InArgument<String> ReportHtmlName { get; set; }
        private XslCompiledTransform transform;

        protected override void Execute(CodeActivityContext context)
        {
            transform = new XslCompiledTransform();

            String input = context.GetValue(this.AnalysisResultsXmlName);
            String output = context.GetValue(this.ReportHtmlName);
            generate(input, output);
        }

        public void generate(String input, String output)
        {
            try
            {
                String filename = "htmlReportTemplate.xslt";
                transform.Load(filename);
                transform.Transform(input, output);
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Error while generating report: " + e.Message);
            }
        }

    }
}



using System;
using System.Collections.Generic;
using System.Activities;
using Antlr.Runtime.Tree;
using System.Xml;
using System.IO;

namespace JavaScriptTranslatorActivities
{

    public sealed class XmlTranslatorActivity : CodeActivity
    {

        public InArgument<CommonTree> Ast { get; set; }
        public OutArgument<String> Xml { get; set; }
        public InArgument<String> OutputFileName { get; set; }

        protected override void Execute(CodeActivityContext context)
        {
            Console.WriteLine("AstToXmlParserActivity - executed");

            CommonTree ast = context.GetValue(this.Ast);

            string outputFileName = context.GetValue(this.OutputFileName);
            if (outputFileName != "")
            {
                generateFile(ast, outputFileName);
            }
            string s = generateString(ast);
            context.SetValue(this.Xml, s);
        }

        public void generateFile(CommonTree ast, string fileName)
        {
            using (XmlWriter writer = XmlWriter.Create(fileName))
            {
                generate(ast, writer);
            }
        }

        public string generateString(CommonTree ast)
        {
            using (var sw = new StringWriter())
            {
                using (var writer = XmlWriter.Create(sw))
                {
                    generate(ast, writer);
                }
                return sw.ToString();
            }
        }

        public XmlDocument generateDocument(CommonTree ast)
        {
            XmlDocument doc = new XmlDocument();
            using (XmlWriter writer = doc.CreateNavigator().AppendChild())
            {
                generate(ast, writer);
            }
            return doc;
        }

        public void generate(CommonTree ast, XmlWriter writer)
        {
            try
            {
                writer.WriteStartDocument();

                writeXMLNode(ast, writer);

                writer.WriteEndDocument();
                writer.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error while translating AST: " + e.Message);
            }
        }

        public void writeXMLNode(CommonTree ast, XmlWriter writer)
        {
            writer.WriteStartElement(ast.ToString());
            //writer.WriteAttributeString("line", ast.Token.TokenIndex.ToString());

            IList<CommonTree> children = ast.Children as IList<CommonTree>;
            if (ast.Children != null)
            {
                CommonTree firstChild = (CommonTree)ast.Children[0];
                if (ast.Children[0] is CommonErrorNode)
                {
                    createXMLErrorNode((CommonErrorNode)ast.Children[0], writer);
                } 
                else if (firstChild.Token.TokenIndex > 0) 
                {
                    writer.WriteAttributeString("value", firstChild.Token.Text);
                } 
                else 
                {
                    writeXMLNode(firstChild as CommonTree, writer);
                }

                for (int i = 1; i < ast.ChildCount; i++)
                {
                    if (ast.Children[i] is CommonErrorNode)
                    {
                        createXMLErrorNode((CommonErrorNode)ast.Children[i], writer);
                    }
                    else
                    {
                        writeXMLNode(ast.Children[i] as CommonTree, writer);
                    }
                }

            }
            writer.WriteEndElement();
        }

        public void createXMLErrorNode(CommonErrorNode error, XmlWriter writer)
        {
            writer.WriteStartElement("ERROR");
            writer.WriteAttributeString("value", error.ToStringTree());
            writer.WriteEndElement();
        }

    }
}

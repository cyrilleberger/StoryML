#include "Extension.h"

#include <QDebug>
#include <QProcess>

#include <KSyntaxHighlighting/Definition>
#include <KSyntaxHighlighting/SyntaxHighlighter>
#include <KSyntaxHighlighting/Theme>

Extension::Extension(QObject* _parent) : QObject(_parent)
{
}

Extension::~Extension()
{
}

void Extension::setSyntaxHighlighting(QQuickTextDocument* textDocument, const QString& _highlightingName)
{
  KSyntaxHighlighting::SyntaxHighlighter* sh = new KSyntaxHighlighting::SyntaxHighlighter(textDocument->textDocument());
  sh->setTheme(m_repository.defaultTheme(KSyntaxHighlighting::Repository::LightTheme));
  KSyntaxHighlighting::Definition def = m_repository.definitionForName(_highlightingName);
  if(def.isValid())
  {
    sh->setDefinition(def);
  } else {
    qWarning() << "No syntax definition for " << _highlightingName;
  }
}

QString Extension::formulaFile(const QString& _formula, const QColor& _color, bool _centered)
{
  QString color_text = QString("%1,%2,%3").arg(_color.redF()).arg(_color.greenF()).arg(_color.blueF());
  QString key = _formula + color_text + QString::number(_centered);
  qDebug() << "key " << key;
  if(m_formulas.contains(key))
  {
    return "file://" + m_formulas.value(key)->path() + "/formula.png";
  }

  QTemporaryDir* dir = new QTemporaryDir;

  QString formulaFileName = dir->path() + "/formula.tex";

  QFile formulaFile(formulaFileName);
  formulaFile.open(QIODevice::WriteOnly | QIODevice::Text);

  formulaFile.write("\\documentclass[border=2pt]{standalone}\n"
                    "\\usepackage[utf8]{inputenc}\n"
                    "\\usepackage{amsmath}\n"
                    "\\usepackage{varwidth}\n"
                    "\\usepackage{color}\n"
                    "\\usepackage{fullpage}\n"
                    "\\usepackage{amssymb}\n"
                    "\\begin{document}\n"
                    "\\begin{varwidth}{\\linewidth}\n");

  if(_centered)
  {
    formulaFile.write("\\begin{center}\n");
  }
  formulaFile.write("{\\color[rgb]{" + color_text.toUtf8() + "} $" + _formula.toUtf8() + " $ }\n");
  if(_centered)
  {
    formulaFile.write("\\end{center}\n");
  }
  formulaFile.write("\\end{varwidth}\n"
                    "\\end{document}\n");

  formulaFile.close();

  QProcess process;
  process.setWorkingDirectory(dir->path());
  qDebug() << "pdflatex starting...";
  process.start("pdflatex", QStringList() << "--interaction" << "nonstopmode" << "--jobname" << "formula" << "\\input{" + formulaFileName + "}");
  process.waitForFinished();
  qDebug() << "pdflatex finished...";

  qDebug() << "convert starting...";
  process.start("convert", QStringList() << "-trim" << "-density" << "600" << "formula.pdf" << "-quality" << "90" << "formula.png");
  process.waitForFinished();
  qDebug() << "convert finished...";
  m_formulas[key] = dir;

  return "file://" + dir->path() + "/formula.png";
}

QString Extension::mimeTypeForUrl(const QUrl& _url)
{
  return m_mimeDatabase.mimeTypeForUrl(_url).name();
}

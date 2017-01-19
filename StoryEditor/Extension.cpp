#include "Extension.h"

#include <Definition>
#include <SyntaxHighlighter>
#include <Theme>

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

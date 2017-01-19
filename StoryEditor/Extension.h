#ifndef _STORYML_EXTENSION_H_
#define _STORYML_EXTENSION_H_

#include <QObject>

#include <QQuickTextDocument>
#include <Repository>

class Extension : public QObject
{
  Q_OBJECT
public:
  Extension(QObject* _parent);
  ~Extension();
  Q_INVOKABLE void setSyntaxHighlighting(QQuickTextDocument* textDocument, const QString& _highlightingName);
private:
  KSyntaxHighlighting::Repository m_repository;
};

#endif

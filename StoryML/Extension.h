#ifndef _STORYML_EXTENSION_H_
#define _STORYML_EXTENSION_H_

#include <QObject>

#include <QQuickTextDocument>
#include <Repository>
#include <QTemporaryDir>
#include <QMimeDatabase>

class Extension : public QObject
{
  Q_OBJECT
public:
  Extension(QObject* _parent);
  ~Extension();
  Q_INVOKABLE void setSyntaxHighlighting(QQuickTextDocument* textDocument, const QString& _highlightingName);
  Q_INVOKABLE QString formulaFile(const QString& _formula, const QColor& _color, bool _centered);
  Q_INVOKABLE QString mimeTypeForUrl(const QUrl& _url);
private:
  KSyntaxHighlighting::Repository m_repository;
  QHash<QString, QTemporaryDir*> m_formulas;
  QMimeDatabase m_mimeDatabase;
};

#endif

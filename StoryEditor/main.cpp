#include <QApplication>
#include <QCommandLineParser>

#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
  QApplication app(argc, argv);
  QCoreApplication::setApplicationName("StoryEditor");
  QCoreApplication::setApplicationVersion("1.0");

  QCommandLineParser parser;
  parser.setApplicationDescription("Application for editing and playing StoryML files.");
  parser.addHelpOption();
  parser.addVersionOption();
  parser.addPositionalArgument("file", QCoreApplication::translate("main", "The file to open."));
  parser.process(app);

  const QStringList args = parser.positionalArguments();
  QUrl filename = args.empty() ? QUrl() : QUrl::fromUserInput(args.first());

  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("cmd_filename", filename);
  engine.addImportPath("qrc:/qml");
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}

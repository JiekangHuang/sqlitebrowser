#ifndef FILTERTABLEHEADER_H
#define FILTERTABLEHEADER_H

#include <QHeaderView>
#include <vector>

class QTableView;
class FilterLineEdit;

class FilterTableHeader : public QHeaderView
{
    Q_OBJECT

public:
    explicit FilterTableHeader(QTableView* parent = nullptr);
    QSize sizeHint() const override;
    bool hasFilters() const {return (filterWidgets.size() > 0);}
    
public slots:
    void generateFilters(size_t number, bool showFirst = false);
    void adjustPositions();
    void clearFilters();
    void setFilter(size_t column, const QString& value);

signals:
    void filterChanged(int column, QString value);
    void addCondFormat(int column, QString filter);
    void allCondFormatsCleared(int column);
    void condFormatsEdited(int column);

protected:
    void updateGeometries() override;

private slots:
    void inputChanged(const QString& new_value);
    void addFilterAsCondFormat(const QString& filter);
    void clearAllCondFormats();
    void editCondFormats();

private:
    std::vector<FilterLineEdit*> filterWidgets;
};

#endif

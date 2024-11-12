report 85000 DOCTableName
{
    DefaultLayout = RDLC;
    RDLCLayout = './DOCTableName.rdlc';
    Caption = '<DocumentName>';

    dataset
    {
        dataitem(DOCTableNameHeader; DOCTableNameHeader)
        {
            column(CompanyName; CompanyName)
            {
            }
            column(PrintingDate; Format(Today, 0, 4))
            {
            }
            column(PageNo; 1)
            {
            }
            column(Title; Title)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(DocumentHeaderDocumentNo; "No.")
            {
            }
            column(DocumentHeaderDocumentNoCaption; FieldCaption("No."))
            {
            }
            column(DocumentHeaderPostingDate; "Posting Date")
            {
            }
            column(DocumentHeaderPostingDateCaption; FieldCaption("Posting Date"))
            {
            }
            column(DocumentHeaderDescription; Description)
            {
            }
            column(DocumentHeaderDescripcionCaption; FieldCaption(Description))
            {
            }
            dataitem(DOCTableNameLine; DOCTableNameLine)
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(DocumentLineDescription; Description)
                {
                }
                column(DocumentLineDescriptionCaption; FieldCaption(Description))
                {
                }
                column(DocumentLineDate; Date)
                {
                }
                column(DocumentLineDateCaption; FieldCaption(Date))
                {
                }
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Title: Label '<DocumentName>';
        PageNoCaptionLbl: Label 'Page';
}


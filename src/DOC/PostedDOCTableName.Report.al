report 85001 PostedDOCTableName
{
    DefaultLayout = RDLC;
    RDLCLayout = './PostedDOCTableName.rdlc';
    Caption = 'Posted <DocumentName>';

    dataset
    {
        dataitem(PostedDOCTableNameHeader; PostedDOCTableNameHeader)
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
            dataitem(PostedDOCTableNameLine; PostedDOCTableNameLine)
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
        Title: Label 'Posted <DocumentName>';
        PageNoCaptionLbl: Label 'Page';
}


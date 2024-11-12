report 85040 DIAJournalNameEntries
{
    DefaultLayout = RDLC;
    RDLCLayout = './DIAJournalNameEntries.rdlc';
    Caption = '<JournalName> Entries';

    dataset
    {
        dataitem(DIAJournalNameEntry; DIAJournalNameEntry)
        {
            RequestFilterFields = "Posting Date";
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(Titulo; Titulo)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltroRegistros; FiltroRegistros)
            {
            }
            column(Fecha; "Posting Date")
            {
            }
            column(FechaCaption; FechaCaptionLbl)
            {
            }
            column(Descripcion; DIAJournalNameEntry.Description)
            {
            }
            column(DescripcionCaption; DescripcionCaptionLbl)
            {
            }
            column(NoDocumento; DIAJournalNameEntry."Document No.")
            {
            }
            column(NoDocumentoCaption; NoDocumentoCaptionLbl)
            {
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

    trigger OnPreReport()
    begin
        FiltroRegistros := DIAJournalNameEntry.GetFilters;
    end;

    var
        FiltroRegistros: Text[500];
        Titulo: Label '<Titulo del informe>';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FechaCaptionLbl: Label 'Fecha registro';
        DescripcionCaptionLbl: Label 'Descripción';
        NoDocumentoCaptionLbl: Label 'Nº documento';
}


table 85020 CODTableName
{
    // COD Cadenas a sustituir
    // =================================
    // CODTableName
    // TableCaptionENU
    // TableCaptionESP
    // CODPageName
    // PageCaptionENU
    // PageCaptionESP

    Caption = 'TableCaptionENU';
    DrillDownPageID = CODPageName;
    LookupPageID = CODPageName;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}


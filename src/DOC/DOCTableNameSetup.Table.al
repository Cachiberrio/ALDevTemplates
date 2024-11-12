table 85005 DOCTableNameSetup
{
    Caption = '<DocumentName> Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "DOCTableCaptionENU No. Series"; Code[10])
        {
            Caption = 'DOCTableCaptionENU No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


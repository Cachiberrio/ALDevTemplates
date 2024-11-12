table 85051 MCPTableNameIntegrSetup
{
    Caption = 'MCPTableCaptionENU Integration Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "MCPTableName No. Series"; Code[10])
        {
            Caption = 'MCPTableCaptionENU No. Series';
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


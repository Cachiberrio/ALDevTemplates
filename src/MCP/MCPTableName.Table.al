table 85050 MCPTableName
{

    Caption = 'MCPTableCaptionENU';
    DrillDownPageID = MCPTableNameList;
    LookupPageID = MCPTableNameList;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    IntegrTableIntegrationSetup.Get;
                    NoSeries.TestManual(IntegrTableIntegrationSetup."MCPTableName No. Series");
                    "No. series" := '';
                end;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(4; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(6; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(7; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(8; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.", '', "No.", DATABASE::MCPTableName);
            end;
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; County; Text[30])
        {
            Caption = 'County';
        }
        field(11; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if xRec."Customer No." <> '' then
                    if not Confirm(ConfirmCustomerChange) then
                        Error(ErrorCancelledTransaction);
            end;
        }
        field(12; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
        }
        field(13; "Leaving Date"; Date)
        {
            Caption = 'Leaving Date';
        }
        field(14; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(15; "No. series"; Code[10])
        {
            Caption = 'No. series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(19; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if xRec."Vendor No." <> '' then
                    if not Confirm(ConfirmVendorChange) then
                        Error(ErrorCancelledTransaction);
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Entry Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField("Customer No.", '');
        TestField("Vendor No.", '');
    end;

    trigger OnInsert()
    var
        MCPTableName: Record MCPTableName;
    begin
        if "No." = '' then begin
            IntegrTableIntegrationSetup.Get;
            IntegrTableIntegrationSetup.TestField("MCPTableName No. Series");

            "No. Series" := IntegrTableIntegrationSetup."MCPTableName No. Series";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
            while MCPTableName.Get("No.") do
                "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    trigger OnModify()
    var
        Cliente: Record Customer;
        Proveedor: Record Vendor;
    begin
    end;

    var
        PostCode: Record "Post Code";
        IntegrTableIntegrationSetup: Record MCPTableNameIntegrSetup;
        NoSeries: Codeunit "No. Series";
        IntegrTableIntegrationMgt: Codeunit MCPTableNameIntegrMgt;
        ConfirmCustomerChange: Label 'Do you really want to change related customer no.?';
        ConfirmVendorChange: Label 'Do you really want to change related vendor no.?';
        ErrorCancelledTransaction: Label 'Transaction was cancelled.';
        PhoneNoCannotContainLettersErr: Label 'must not contain letters';

    [Scope('Cloud')]
    procedure AssistEdit(OldIntegrTable: Record MCPTableName): Boolean
    var
        MCPTableName: Record MCPTableName;
    begin
        MCPTableName := Rec;
        IntegrTableIntegrationSetup.Get;
        IntegrTableIntegrationSetup.TestField("MCPTableName No. Series");
        if NoSeries.LookupRelatedNoSeries(IntegrTableIntegrationSetup."MCPTableName No. Series", OldIntegrTable."No. series", MCPTableName."No. series") then begin
            MCPTableName."No." := NoSeries.GetNextNo(MCPTableName."No. Series");
            Rec := MCPTableName;
            exit(true);
        end;
    end;

    [Scope('Cloud')]
    procedure CreateCustomer()
    var
        Clie: Record Customer;
    begin
        IntegrTableIntegrationMgt.CreateCustomerFromMCPTableName(Rec);
    end;

    [Scope('Cloud')]
    procedure CreateVendor()
    var
        Proveedor: Record Vendor;
    begin
        IntegrTableIntegrationMgt.CreateVendorFromMCPTableName(Rec);
    end;
}


codeunit 85050 MCPTableNameIntegrMgt
{

    trigger OnRun()
    begin
    end;

    var
        MsgCreation: Label '%1 %2 was created correctly.';

    local procedure FindMCPTableNamePerCustomerNo(CustomerNo: Code[20]; var MCPTableName: Record MCPTableName)
    begin
        MCPTableName.Reset;
        MCPTableName.SetCurrentKey("Customer No.");
        MCPTableName.SetRange("Customer No.", CustomerNo);
        if not MCPTableName.FindSet then
            MCPTableName.Init;
    end;

    local procedure FindMCPTableNamePerVendorNo(VendorNo: Code[20]; var MCPTableName: Record MCPTableName)
    begin
        MCPTableName.Reset;
        MCPTableName.SetCurrentKey("Vendor No.");
        MCPTableName.SetRange("Vendor No.", VendorNo);
        if not MCPTableName.FindSet then
            MCPTableName.Init;
    end;

    [Scope('Cloud')]
    procedure CreateCustomerFromMCPTableName(var MCPTableName: Record MCPTableName)
    var
        Customer: Record Customer;
    begin
        MCPTableName.TestField("No.");
        MCPTableName.TestField("Customer No.", '');
        CopyToCustomer(MCPTableName, Customer);
        CopyCustomerTemplateFields(MCPTableName, Customer);
        Customer.Insert(true);
        MCPTableName."Customer No." := Customer."No.";
        MCPTableName.Modify;
        Message(MsgCreation, Customer.TableCaption, Customer."No.");
    end;

    [Scope('Cloud')]
    procedure CopyCustomerTemplateFields(var MCPTableName: Record MCPTableName; var Customer: Record Customer)
    var
        ConfigTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Customer);
        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
    end;

    [Scope('Cloud')]
    procedure CopyToCustomer(var MCPTableName: Record MCPTableName; var Customer: Record Customer)
    begin
        Customer.Validate(Name, MCPTableName.Name);
        Customer."Name 2" := MCPTableName."Name 2";
        Customer.Address := MCPTableName.Address;
        Customer."Address 2" := MCPTableName."Address 2";
        Customer.City := MCPTableName.City;
        Customer."Phone No." := MCPTableName."Phone No.";
        Customer."VAT Registration No." := MCPTableName."VAT Registration No.";
        Customer."Post Code" := MCPTableName."Post Code";
        Customer.County := MCPTableName.County;
        Customer."Country/Region Code" := MCPTableName."Country/Region Code";
    end;

    [Scope('Cloud')]
    procedure CopyToVendor(var MCPTableName: Record MCPTableName; var Vendor: Record Vendor)
    begin
        Vendor.Validate(Name, MCPTableName.Name);
        Vendor."Name 2" := MCPTableName."Name 2";
        Vendor.Address := MCPTableName.Address;
        Vendor."Address 2" := MCPTableName."Address 2";
        Vendor.City := MCPTableName.City;
        Vendor."Phone No." := MCPTableName."Phone No.";
        Vendor."VAT Registration No." := MCPTableName."VAT Registration No.";
        Vendor."Post Code" := MCPTableName."Post Code";
        Vendor.County := MCPTableName.County;
        Vendor."Country/Region Code" := MCPTableName."Country/Region Code";
    end;

    [Scope('Cloud')]
    procedure CopyVendorTemplateFields(var MCPTableName: Record MCPTableName; var RecProveedor: Record Vendor)
    var
        ConfigTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecProveedor);
        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
    end;

    [Scope('Cloud')]
    procedure CreateVendorFromMCPTableName(var MCPTableName: Record MCPTableName)
    var
        Vendor: Record Vendor;
    begin
        MCPTableName.TestField("No.");
        MCPTableName.TestField("Vendor No.", '');
        CopyToVendor(MCPTableName, Vendor);
        CopyVendorTemplateFields(MCPTableName, Vendor);
        Vendor.Insert(true);
        MCPTableName."Vendor No." := Vendor."No.";
        MCPTableName.Modify;
        Message(MsgCreation, Vendor.TableCaption, Vendor."No.");
    end;

    [EventSubscriber(ObjectType::Table, 85050, 'OnAfterModifyEvent', '', false, false)]
    [Scope('Cloud')]
    procedure UpdateCustomerFromMCPTableName(var Rec: Record MCPTableName; var xRec: Record MCPTableName; RunTrigger: Boolean)
    var
        Customer: Record Customer;
    begin
        if not RunTrigger then
            exit;
        if not Customer.Get(Rec."Customer No.") then
            exit;
        CopyToCustomer(Rec, Customer);
        Customer.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, 85050, 'OnAfterModifyEvent', '', false, false)]
    [Scope('Cloud')]
    procedure UpdateVendorFromMCPTableName(var Rec: Record MCPTableName; var xRec: Record MCPTableName; RunTrigger: Boolean)
    var
        Vendor: Record Vendor;
    begin
        if not Vendor.Get(Rec."Vendor No.") then
            exit;
        CopyToVendor(Rec, Vendor);
        Vendor.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterModifyEvent', '', false, false)]
    local procedure UpdateMCPTableNameFromCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    var
        MCPTableName: Record MCPTableName;
        Vendor: Record Vendor;
    begin
        if not RunTrigger then
            exit;
        FindMCPTableNamePerCustomerNo(Rec."No.", MCPTableName);
        if MCPTableName."No." = '' then
            exit;
        MCPTableName.Name := Rec.Name;
        MCPTableName."Name 2" := Rec."Name 2";
        MCPTableName.Address := Rec.Address;
        MCPTableName."Address 2" := Rec."Address 2";
        MCPTableName.City := Rec.City;
        MCPTableName."Phone No." := Rec."Phone No.";
        MCPTableName."VAT Registration No." := Rec."VAT Registration No.";
        MCPTableName."Post Code" := Rec."Post Code";
        MCPTableName.County := Rec.County;
        MCPTableName."Country/Region Code" := Rec."Country/Region Code";
        MCPTableName.Modify(false);
        if Vendor.Get(MCPTableName."Vendor No.") then begin
            CopyToVendor(MCPTableName, Vendor);
            Vendor.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnAfterModifyEvent', '', false, false)]
    local procedure UpdateMCPTableNameFromVendor(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    var
        MCPTableName: Record MCPTableName;
        Customer: Record Customer;
    begin
        if not RunTrigger then
            exit;
        FindMCPTableNamePerVendorNo(Rec."No.", MCPTableName);
        if MCPTableName."No." = '' then
            exit;
        MCPTableName.Name := Rec.Name;
        MCPTableName."Name 2" := Rec."Name 2";
        MCPTableName.Address := Rec.Address;
        MCPTableName."Address 2" := Rec."Address 2";
        MCPTableName.City := Rec.City;
        MCPTableName."Phone No." := Rec."Phone No.";
        MCPTableName."VAT Registration No." := Rec."VAT Registration No.";
        MCPTableName."Post Code" := Rec."Post Code";
        MCPTableName.County := Rec.County;
        MCPTableName."Country/Region Code" := Rec."Country/Region Code";
        MCPTableName.Modify(false);
        if Customer.Get(MCPTableName."Customer No.") then begin
            CopyToCustomer(MCPTableName, Customer);
            Customer.Modify;
        end;
    end;
}


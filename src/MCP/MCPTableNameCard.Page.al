page 85051 MCPTableNameCard
{
    Caption = 'MCPTableCaptionENU Card';
    PageType = Card;
    SourceTable = MCPTableName;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Rec.Name)
                {
                }
                field("Name 2"; Rec."Name 2")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(City; Rec.City)
                {
                }
                field(County; Rec.County)
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Entry Date"; Rec."Entry Date")
                {
                }
                field("Leaving Date"; Rec."Leaving Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Maestro")
            {
                Caption = '&Maestro';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page MCPTableNameCard;
                    RunPageLink = "No." = FIELD("No.");
                }
                action(Customer)
                {
                    Caption = 'Customer';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Customer List";
                    RunPageLink = "No." = FIELD("Customer No.");
                    RunPageMode = View;
                }
                action(Vendor)
                {
                    Caption = 'Vendor';
                    Image = VendorLedger;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Vendor List";
                    RunPageLink = "No." = FIELD("Vendor No.");
                    RunPageMode = View;
                }
            }
            group("Acci&ones")
            {
                Caption = 'Acci&ones';
                action("Create Customer")
                {
                    Caption = 'Create Customer';
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.CreateCustomer;
                        CurrPage.Update;
                    end;
                }
                action("Create Vendor")
                {
                    Caption = 'Create Vendor';
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.CreateVendor;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("No.");
    end;
}


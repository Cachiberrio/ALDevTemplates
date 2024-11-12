codeunit 85080 PGPItemPatternManagement
{

    trigger OnRun()
    begin
    end;

    local procedure IsTrackedItem(ItemNo: Code[20]): Boolean
    var
        ItemTrackingCode: Record "Item Tracking Code";
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        if Item."Item Tracking Code" = '' then
            exit(false);
        ItemTrackingCode.Get(Item."Item Tracking Code");
        exit(ItemTrackingCode."Lot Neg. Adjmt. Outb. Tracking");
    end;

    local procedure PostItemLedgerEntry(ItemManagementTemplate: Record PGPItemPatternManagement; DocumentNo: Code[20]; PostingDate: Date; LineNo: Integer)
    var
        ItemJournalLine: Record "Item Journal Line";
        Item: Record Item;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin
        ItemJournalLine.Init;
        ItemJournalLine.Validate("Item No.", ItemManagementTemplate."Item No.");
        Item.Get(ItemJournalLine."Item No.");
        ItemJournalLine."Posting Date" := PostingDate;
        ItemJournalLine."Document Date" := PostingDate;
        ItemJournalLine."Document No." := DocumentNo;
        ItemJournalLine."External Document No." := '';
        ItemJournalLine."Order Type" := ItemJournalLine."Order Type"::" ";
        ItemJournalLine."Order No." := '';
        ItemJournalLine."Order Line No." := 0;
        ItemJournalLine.Description := ItemManagementTemplate.Description;
        ItemJournalLine."Location Code" := ItemManagementTemplate."Location Code";
        ItemJournalLine.Validate(Quantity, ItemManagementTemplate.Quantity);
        ItemJournalLine.Validate("Quantity (Base)", ItemManagementTemplate."Quantity (Base)");
        ItemJournalLine.Validate("Unit Cost", FindItemUnitCost(ItemManagementTemplate."Item No.", ItemManagementTemplate."Qty. per Unit of Measure"));
        ItemJournalLine.Validate(Amount, ItemJournalLine."Quantity (Base)" * ItemJournalLine."Unit Cost");
        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
        ItemJournalLine."Variant Code" := ItemManagementTemplate."Variant Code";
        ItemJournalLine."Unit of Measure Code" := ItemManagementTemplate."Unit Of Measure";
        ItemJournalLine."Qty. per Unit of Measure" := ItemManagementTemplate."Qty. per Unit of Measure";
        ItemJournalLine."Lot No." := ItemManagementTemplate."Lot No.";
        ItemJournalLine."Item Category Code" := Item."Item Category Code";
        ItemJournalLine."Document Line No." := LineNo;
        ItemJournalLine."Inventory Posting Group" := Item."Inventory Posting Group";
        ItemJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        CreateItemTrackingForItemJournalLine(ItemJournalLine);
        ItemJournalLine."Lot No." := '';
        ItemJnlPostLine.RunWithCheck(ItemJournalLine);
        ItemManagementTemplate."Item Ledger Entry No." := ItemJournalLine."Item Shpt. Entry No.";
        ItemManagementTemplate.Modify;
    end;

    local procedure FindItemUnitCost(ItemNo: Code[20]; QtyPerUnitOfMeasure: Decimal): Decimal
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit(0)
        else
            exit(Item."Unit Cost" * QtyPerUnitOfMeasure);
    end;

    procedure CreateItemTrackingForItemJournalLine(LinDiaProd: Record "Item Journal Line")
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        CurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;
        Status: Enum "Reservation Status";
        ReservationEntry: Record "Reservation Entry";
    begin
        if LinDiaProd."Lot No." = '' then
            exit;
        ReservationEntry."Serial No." := LinDiaProd."Serial No.";
        ReservationEntry."Lot No." := LinDiaProd."Lot No.";
        CreateReservEntry.CreateReservEntryFor(DATABASE::"Item Journal Line", LinDiaProd."Entry Type".AsInteger(),
                LinDiaProd."Journal Template Name",
                LinDiaProd."Journal Batch Name",
                0,
                LinDiaProd."Line No.",
                LinDiaProd."Qty. per Unit of Measure",
                LinDiaProd.Quantity,
                LinDiaProd."Quantity (Base)",
                ReservationEntry);
        CreateReservEntry.CreateEntry(LinDiaProd."Item No.",
                LinDiaProd."Variant Code",
                LinDiaProd."Location Code",
                LinDiaProd.Description,
                0D,
                0D, 0, Status::Surplus);
    end;
}


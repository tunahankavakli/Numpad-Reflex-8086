name "Numpad Refleks"

org 100h  ; COM program formati

jmp basla

; ---- VERI BOLUMU (DATA SEGMENT) ----
msg_baslik   db '=== NUMPAD HIZ TESTI ===', 13, 10
             db 'Ekranda cikan RAKAMA (0-9) hizlica bas!', 13, 10
             db '3 Yanlis tus = Oyun Biter. SURE DOLARSA ANINDA BITER!', 13, 10, 10, '$'

msg_tus      db 13, 10, '>>> BAS: $'
msg_dogru    db ' -> HARIKA! Hizlaniyoruz...', '$'
msg_yanlis   db ' -> YANLIS TUS! Hata: $'
msg_zaman    db ' -> SURE DOLDU! Gec kaldin.', 13, 10, '$'
msg_bitti    db 13, 10, 10, '--- OYUN BITTI ---', 13, 10, '$'
msg_skor     db 'Toplam Basarili Skor: $'
msg_ort_sure db 13, 10, 'Ortalama Tepki Suresi: $'
msg_ms       db ' milisaniye', 13, 10, '$' 
msg_hata_sif db 'Hic dogru basamadin! Ortalama sure: 0', 13, 10, '$'

harfler      db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' 
hedef_tus    db ?

hata_sayisi  db 0
skor         dw 0   
zaman_limit  dw 70  ; BASLANGIC SURESI: 70 tick (~4 saniye)
toplam_tick  dw 0   

; ---- KOD BOLUMU (CODE SEGMENT) ----
basla:
    mov ah, 09h
    lea dx, msg_baslik
    int 21h   
    
    mov ah, 09h 
    lea dx, msg_hazir 
    int 21h 

oyun_dongusu:
    ; 1. Rastgele Rakam Secimi (0-9 arasi)
    mov ah, 00h
    int 1Ah       
    mov ax, dx    
    mov dx, 0     
    mov bx, 10    
    div bx        
    
    mov bx, dx
    mov al, harfler[bx]
    mov hedef_tus, al

    ; 2. Ekrana "BAS: X" yazdir
    mov ah, 09h
    lea dx, msg_tus
    int 21h
    
    mov ah, 02h
    mov dl, hedef_tus
    int 21h

    ; 3. Baslangic zamanini al
    mov ah, 00h
    int 1Ah
    mov bx, dx 

bekleme_dongusu:
    mov ah, 01h
    int 16h
    jnz tus_basildi 

    mov ah, 00h
    int 1Ah
    mov cx, dx
    sub cx, bx 
    
    cmp cx, zaman_limit
    jg sure_doldu 
    
    jmp bekleme_dongusu

tus_basildi:
    mov ah, 00h
    int 1Ah
    mov cx, dx
    sub cx, bx 

    mov ah, 00h
    int 16h

    cmp al, hedef_tus
    je dogru_tus

yanlis_tus:
    inc hata_sayisi
    
    mov ah, 09h
    lea dx, msg_yanlis
    int 21h
    
    mov dl, hata_sayisi
    add dl, 30h
    mov ah, 02h
    int 21h
    
    jmp hata_kontrol

sure_doldu:
    ; Klavye bufferini temizle
    mov ah, 0Ch
    mov al, 0
    int 21h
    
    ; Sure doldugu icin direkt mesaji yazdir ve OYUNU BITIR
    mov ah, 09h
    lea dx, msg_zaman
    int 21h
    
    jmp oyun_bitti

dogru_tus:
    inc skor
    add toplam_tick, cx 
    
    cmp zaman_limit, 12  ; ALT LIMIT: 12 tick (~0.6 saniye)
    jle limit_ayni
    sub zaman_limit, 3   

limit_ayni:
    mov ah, 09h
    lea dx, msg_dogru
    int 21h
    
    jmp oyun_dongusu

hata_kontrol:
    cmp hata_sayisi, 3
    jge oyun_bitti
    
    ; Bekleme Suresi KISALTILDI (18 yerine 6 tick, yaklasik 0.3 saniye)
    mov ah, 00h
    int 1Ah
    mov bx, dx
hata_bekle:
    mov ah, 00h
    int 1Ah
    sub dx, bx
    cmp dx, 6  
    jl hata_bekle
    
    ; Bekleme sirasinda klavyeye basildiysa bufferi temizle
    mov ah, 0Ch
    mov al, 0
    int 21h
    
    jmp oyun_dongusu

oyun_bitti:
    mov ah, 09h
    lea dx, msg_bitti
    int 21h
    
    mov ah, 09h
    lea dx, msg_skor
    int 21h
    
    mov ax, skor
    call print_num  

    mov ah, 09h
    lea dx, msg_ort_sure
    int 21h

    cmp skor, 0
    je hic_dogru_yok 

    mov dx, 0
    mov ax, toplam_tick
    mov bx, skor
    div bx 
    
    mov cx, 55
    mul cx 
    
    call print_num
    
    mov ah, 09h
    lea dx, msg_ms
    int 21h

    jmp cikis

hic_dogru_yok:
    mov ah, 09h
    lea dx, msg_hata_sif
    int 21h

cikis:
    mov ah, 4Ch
    int 21h

; ==============================================================
; SAYI YAZDIRMA FONKSIYONU 
; ==============================================================
print_num proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 0   
    mov bx, 10  

bolme_dongusu:
    mov dx, 0   
    div bx      
    push dx     
    inc cx      
    cmp ax, 0   
    jne bolme_dongusu

yazdirma_dongusu:
    pop dx      
    add dl, 30h 
    mov ah, 02h
    int 21h
    loop yazdirma_dongusu
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp
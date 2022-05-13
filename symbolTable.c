#include <stdlib.h>
#include <stdio.h>
#include <string.h> 

typedef enum SymbolType {
    STRING, 
    INT
} SymbolType; 

typedef struct SymbolEntry {
    char * key; 
    char * value;
    SymbolType type; 
    struct SymbolEntry * next; 
} SymbolEntry; 

typedef struct SymbolTable {
    SymbolEntry * top; 
    struct SymbolTable * previousTable; 
} SymbolTable; 

SymbolEntry * newSymbol(char * name, char * value, SymbolType type); 
void printSymbolEntry(SymbolEntry * entry); 
void printSymbolEntryList(SymbolEntry * entry); 
SymbolEntry * getSymbolWithKey(SymbolEntry * entry, char * key); 

SymbolTable * newScope(SymbolTable * previousTable); 
SymbolTable * newEmptySymbolTable(); 
void printSymbolTable(SymbolTable * table);
void addSymbolToTable(SymbolTable * table, SymbolEntry * entry); 
SymbolEntry * getEntryFromTable(SymbolTable * table, char * key); 

// Pure, simple, symbol manipulation

SymbolEntry * newSymbol(char * name, char * value, SymbolType type) {
    SymbolEntry * entry = malloc(sizeof(SymbolEntry)); 
    entry->key = name; 
    entry->value = value; 
    entry->type = type; 
    return entry; 
}

void printSymbolEntry(SymbolEntry * entry) {
    if (entry == NULL)
        printf("<%10s, %20s, %15s >\n", "NONE", "NONE", "NONE"); 
    else 
        printf("<%10s, %20s, %15s >\n", entry->key, entry->value, entry->type == INT ? "type:int" : "type:string"); 
}

void printSymbolEntryList(SymbolEntry * entry) {
    if (entry == NULL)
        return; 
    printSymbolEntry(entry); 
    printSymbolEntryList(entry->next); 
}

// Recurse through the symbol list 

SymbolEntry * getSymbolWithKey(SymbolEntry * entry, char * key) {

    if (entry == NULL)
        return NULL; 
    
    if (strcmp(entry->key, key) == 0)
        return entry; 

    return getSymbolWithKey(entry->next, key); 
}

// Table creation 

SymbolTable * newScope(SymbolTable * previousTable) {
    SymbolTable * table =  malloc(sizeof(SymbolTable)); 
    table->top = NULL; 
    table->previousTable = previousTable; 
    return table; 
}

SymbolTable * newEmptySymbolTable() {
    return newScope(NULL); 
}

// Table debugging 

void printSymbolTable(SymbolTable * table) {

    if (table == NULL) {
        printf("----EOT----\n");
        return; 
    }

    printf("----TABLE---\n"); 
    printSymbolEntryList(table->top); 
    printSymbolTable(table->previousTable); 
}

// Table manipulation and referencing

void addSymbolToTable(SymbolTable * table, SymbolEntry * entry) {
    entry->next = table->top; 
    table->top = entry; 
}

SymbolEntry * getEntryFromTable(SymbolTable * table, char * key) {
    if (table == NULL)
        return NULL; 

    SymbolEntry * res = getSymbolWithKey(table->top, key); 
    return res == NULL ? getEntryFromTable(table->previousTable, key) : res;   
} 




int main() {
  
    SymbolTable * table = newEmptySymbolTable(); 
    SymbolEntry * s1 = newSymbol("i", "hola", STRING); 
    SymbolEntry * s2 = newSymbol("s", "122", INT); 
    SymbolEntry * s3 = newSymbol("j", "this is a string test", STRING); 
    SymbolEntry * s4 = newSymbol("t", "TEST", STRING); 
    SymbolEntry * s5 = newSymbol("p", "BYE", STRING); 

    addSymbolToTable(table, s1); 
    addSymbolToTable(table, s2); 
    addSymbolToTable(table, s3); 
    addSymbolToTable(table, s4); 
    addSymbolToTable(table, s5); 

    table = newScope(table); 

    SymbolEntry * s6 = newSymbol("j", "IM J IN THE NEW SCOPE", STRING); 
    SymbolEntry * s7 = newSymbol("tuki", "fiji", STRING); 

    addSymbolToTable(table, s6); 
    addSymbolToTable(table, s7); 

    printSymbolTable(table); 
    
    SymbolEntry * res = getEntryFromTable(table, "popo"); 
    printSymbolEntry(res); 
    return 0; 
}
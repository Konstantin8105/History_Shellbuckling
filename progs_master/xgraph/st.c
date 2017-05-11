
#include "aparms.h"

/*
 * String Table (Hash) Package
 *
 * Peter Moore
 * University of California, Berkeley
 * 1985
 *
 * This is a general purpose hash table package.
 */

#define max(a,b)    ((a) > (b) ? (a) : (b))
#define nil(type)   ((type *) 0)
#define alloc(type) (type *) Malloc(sizeof(type))

#define ABS(x)      ((x) < 0 ? -(x) : (x))


char    st_pkg_name[] = "st";

/* Possible error conditions */

char   *st_no_mem  = "out of memory";
char   *st_bad_ret = "bad return code from function passed to st_foreach";
char   *st_bad_gen = "null or zero generator";



/* ================================================================= */
/* ================================================================= */

/*************/
/*  do_hash  */
/*************/

int  do_hash( char     *key   ,
              st_table *table )
 
/* use the appropiate hash function */
{
    int       size = table->num_bins;
    int       hash;

    if       (table->hash == st_ptrhash) {
      hash = (int)((unsigned)*key >> 2) % size;
    }
    else if  (table->hash == st_ptrhash) {
      hash = ABS((int)*key) % size;
    }
    else {
      hash = table->hash(key, size);
    }

    return (hash);
}


/**************/
/*  is_equal  */
/**************/

int  is_equal( int    func() ,
               char  *x      ,
               char  *y      )
 
/* check whether pointers (x) and (y) are equal */
{
    int       dif;

    if      (*func == st_ptrcmp) {
      dif =  (int)(*x) - (int)(*y);
    }
    else if (*func == st_numcmp) {
      dif =  (int)(*x) - (int)(*y);
    }
    else {
      dif =  func(x, y);
    }

    return (dif == 0);
}


/*******************/
/*  ptr_not_equal  */
/*******************/

int  ptr_not_equal( st_table        *table ,
                    st_table_entry  *ptr   ,
                    char            *key   )
 
/* check whether pointers are non-null & equal */
{
    int       ok1;
    int       ok2;

    ok1 = ( ptr != (st_table_entry *)0 );

    if ( !ok1 ) return (0);

    ok2 =   !is_equal( table->compare, key, ptr->key );

    return (ok1 && ok2);
}


/****************/
/*  find_entry  */
/****************/

void  find_entry( st_table        *table ,
                  int              hash  ,
                  char            *key   ,
                  st_table_entry **ptro  ,
                  st_table_entry **last  )

/* check for table entry */
{
    st_table_entry  *ptr;

    last  =  &table->bins[hash];
    ptr   =  *last;

    while ( ptr_not_equal(table, ptr, key) ) {
        last  =  &ptr->next;
        ptr   =  *last;
    }
 
    if ( ( ptr != (st_table_entry *)0 ) && table->reorder_flag ) {
	*last              =  ptr->next;
	 ptr->next         =  table->bins[hash];
	 table->bins[hash] =  ptr;
    }

    *ptro = ptr;

}

/****************/
/*  add_direct  */
/****************/

void  add_direct( st_table        *table ,
                  char            *key   ,
                  char            *value ,
                  int              hashi ,
                  st_table_entry **new   )

/* add new table entry */
{
    int              hash;
    st_table_entry  *bin;

    if ( table->num_entries/table->num_bins >= table->max_density ) {

	(void)rehash(table);

	hash = do_hash(key, table);
    }
    else {
	hash = hashi;
    }

    bin = alloc(st_table_entry);

    if ( bin != (st_table_entry *)0 ) {
         bin->key          = key;
         bin->record       = value;
         bin->next         = table->bins[hash];
         table->bins[hash] = bin;
         table->num_entries++;
    }
    else {
	errRaise(st_pkg_name, ST_NO_MEM, st_no_mem);
	/* NOTREACHED */ 
    }

    *new = bin;
}

/* ================================================================= */
/* ================================================================= */

/*******************************/
/*  st_init_table_with_params  */
/*******************************/

st_table *st_init_table_with_params( int    (*compare) () , 
                                     int    (*hash)    () , 
                                     int    size          , 
                                     int    density       , 
                                     double grow_factor   , 
                                     int    reorder_flag  ) 

/* Detailed table allocator */
{
    st_table *new;

    new = alloc(st_table);

    if (!new) {
	errRaise(st_pkg_name, ST_NO_MEM, st_no_mem);
	/* NOTREACHED */
    }

    new->compare      = compare;
    new->hash         = hash;
    new->num_entries  = 0;
    new->max_density  = density;
    new->grow_factor  = grow_factor;
    new->reorder_flag = reorder_flag;
    if (size <= 0) {
	size = 1;
    }
    new->num_bins     = size;
    new->bins         = (st_table_entry **) Calloc((unsigned) size, sizeof(st_table_entry *));

    if (!new->bins) {
	Free((char *) new);
	errRaise(st_pkg_name, ST_NO_MEM, st_no_mem);
	/* NOTREACHED */
    }

    return new;
}


/*******************/
/*  st_init_table  */
/*******************/

st_table *st_init_table( int (*compare) () , 
                         int (*hash)    () ) 

/* Default table allocator */
{
    return st_init_table_with_params(compare,
                                     hash,
                                     ST_DEFAULT_INIT_TABLE_SIZE,
				     ST_DEFAULT_MAX_DENSITY,
				     ST_DEFAULT_GROW_FACTOR,
				     ST_DEFAULT_REORDER_FLAG);
}



/*******************/
/*  st_Free_table  */
/*******************/

void st_Free_table( st_table *table ) 

/* Destroy a table */
{
    register st_table_entry *ptr,
           *next;
    int     i;

    for (i = 0; i < table->num_bins; i++) {
	ptr = table->bins[i];
	while (ptr != nil(st_table_entry)) {
	    next = ptr->next;
	    Free((char *) ptr);
	    ptr = next;
	}
    }
    Free((char *) table->bins);
    Free((char *) table);
}



/***************/
/*  st_lookup  */
/***************/

int  st_lookup( st_table  *table , 
                char      *key   , 
                char     **value ) 

/* Look up item in table -- return zero if not found */
{
    int              hash_val;
    st_table_entry  *ptr,
                   **last;

    hash_val = do_hash(key, table);

    find_entry(table, hash_val, key, &ptr, last);

    if (ptr == nil(st_table_entry)) {
	return 0;
    }
    else {
	if (value != nil(char *))
	    *value = ptr->record;
	return 1;
    }
}



/***************/
/*  st_insert  */
/***************/

int  st_insert( st_table *table , 
                char     *key   , 
                char     *value ) 

/* Insert an item into the table - replacing if it already exists */
{
    int              hash_val;
    st_table_entry  *new;
    st_table_entry  *ptr,
                   **last;

    hash_val = do_hash(key, table);

    find_entry(table, hash_val, key, &ptr, last);

    if (ptr == nil(st_table_entry)) {
        add_direct(table, key, value, hash_val, &new);
	return 0;
    }
    else {
	ptr->record = value;
	return 1;
    }
}


/*******************/
/*  st_add_direct  */
/*******************/

void  st_add_direct( st_table *table , 
                     char     *key   , 
                     char     *value ) 

/* Add item to table without checking for existing item */
{
    int              hash_val;
    st_table_entry  *new;

    hash_val = do_hash(key, table);

    add_direct(table, key, value, hash_val, &new);
}


/********************/
/*  st_find_or_add  */
/********************/

int  st_find_or_add( st_table *table , 
                     char     *key   , 
                     char   ***slot  ) 

/* Return slot for key - make one if one doesn't exist */
{
    int              hash_val;
    st_table_entry  *new;
    st_table_entry  *ptr,
                   **last;

    hash_val = do_hash(key, table);

    find_entry(table, hash_val, key, &ptr, last);

    if (ptr == nil(st_table_entry)) {
        add_direct(table, key, (char *)0, hash_val, &new);

	if (slot != nil(char **)) *slot = &new->record;
	return 0;
    }
    else {
	if (slot != nil(char **)) *slot = &ptr->record;
	return 1;
    }
}


/*************/
/*  st_find  */
/*************/

int  st_find( st_table *table  , 
              char     *key    , 
              char     ***slot ) 

/* Finds an entry in table */
{
    int     hash_val;
    st_table_entry *ptr,
          **last;

    hash_val = do_hash(key, table);

    find_entry(table, hash_val, key, &ptr, last);

    if (ptr == nil(st_table_entry)) {
	return 0;
    }
    else {
	if (slot != nil(char **)) *slot = &ptr->record;
	return 1;
    }
}


/************/
/*  rehash  */
/************/

void  rehash( st_table *table ) 

/* Grows table */
{
    register st_table_entry *ptr,
           *next,
          **old_bins = table->bins;
    int     i,
            old_num_bins = table->num_bins,
            hash_val;

    table->num_bins = table->grow_factor * old_num_bins;

    if ( table->num_bins % 2 == 0 )   table->num_bins += 1;

    table->bins = (st_table_entry **) Calloc((unsigned) table->num_bins,
				             sizeof(st_table_entry *));

    if (!table->bins) {
	/* If out of memory: don't resize */
	table->bins     = old_bins;
	table->num_bins = old_num_bins;
	return;
    }

    table->num_entries = 0;

    for (i = 0; i < old_num_bins; i++) {
	ptr = old_bins[i];
	while (ptr != nil(st_table_entry)) {
	    next                  = ptr->next;
	    hash_val              = do_hash(ptr->key, table);
	    ptr->next             = table->bins[hash_val];
	    table->bins[hash_val] = ptr;
	    ptr                   = next;
	    table->num_entries++;
	}
    }

    Free((char *) old_bins);
}


/*************/
/*  st_copy  */
/*************/

st_table *st_copy( st_table *old_table ) 
{
    st_table       *new_table;
    st_table_entry *ptr,
                   *new;
    int             i,
            num_bins = old_table->num_bins;

    new_table = alloc(st_table);
    if (new_table == nil(st_table)) {
	errRaise(st_pkg_name, ST_NO_MEM, st_no_mem);
	/* NOTREACHED */
    }

    *new_table = *old_table;
    new_table->bins =
	(st_table_entry **) Calloc((unsigned) num_bins, sizeof(st_table_entry *));

    if (new_table->bins == nil(st_table_entry *)) {
	Free((char *) new_table);
	errRaise(st_pkg_name, ST_NO_MEM, st_no_mem);
	/* NOTREACHED */
    }

    for (i = 0; i < num_bins; i++) {
	new_table->bins[i] = nil(st_table_entry);
	ptr = old_table->bins[i];
	while (ptr != nil(st_table_entry)) {
	    new = alloc(st_table_entry);
	    if (new == nil(st_table_entry)) {
		Free((char *) new_table->bins);
		Free((char *) new_table);
		errRaise(st_pkg_name, ST_NO_MEM, st_no_mem);
		/* NOTREACHED */
	    }
	    *new = *ptr;
	    new->next = new_table->bins[i];
	    new_table->bins[i] = new;
	    ptr = ptr->next;
	}
    }
    return new_table;
}


/***************/
/*  st_delete  */
/***************/

int  st_delete( st_table  *table , 
                char     **keyp  , 
                char     **value ) 
{
    int             hash_val;
    char           *key = *keyp;
    st_table_entry *ptr,
                  **last;

    hash_val = do_hash(key, table);

    find_entry(table, hash_val, key, &ptr, last);

    if (ptr == nil(st_table_entry)) {
	return 0;
    }

    *last = ptr->next;
    if (value != nil(char *)) *value = ptr->record;
    *keyp = ptr->key;
    Free((char *) ptr);
    table->num_entries--;
    return 1;
}


/****************/
/*  st_foreach  */
/****************/

int  st_foreach( st_table               *table , 
                 enum st_retval (*func) ()     , 
                 char                   *arg   ) 
{
    st_table_entry *ptr,
                  **last;
    enum st_retval  retval;
    int     i;

    for (i = 0; i < table->num_bins; i++) {
	last = &table->bins[i];
	ptr = *last;
	while (ptr != nil(st_table_entry)) {
	    retval = (*func) (ptr->key, ptr->record, arg);
	    switch (retval) {
	      case ST_CONTINUE:
		last = &ptr->next;
		ptr = *last;
		break;
	      case ST_STOP:
		return 0;
	      case ST_DELETE:
		*last = ptr->next;
		Free((char *) ptr);
		ptr = *last;
		break;
	      default:
		errRaise(st_pkg_name, ST_BAD_RET, st_bad_ret);
		/* NOTREACHED */
	    }
	}
    }
    return 1;
}


/****************/
/*  st_strhash  */
/****************/

int  st_strhash( char *string  , 
                 int   modulus ) 
{
    register int val = 0;
    register int c;

    while ((c = *string++) != '\0') {
	val = val * 997 + c;
    }

    return ((val < 0) ? -val : val) % modulus;
}


/****************/
/*  st_numhash  */
/****************/

int  st_numhash( char *key  , 
                 int   size ) 
{
    return ( ABS((int)*key) % size );
}


/****************/
/*  st_ptrhash  */
/****************/

int  st_ptrhash( char *key  , 
                 int   size ) 
{
    return ( (int)((unsigned)*key >> 2) % size );

}


/***************/
/*  st_numcmp  */
/***************/

int  st_numcmp( char *x , 
                char *y ) 
{
    return ( (int)*x - (int)*y );
}


/***************/
/*  st_ptrcmp  */
/***************/

int  st_ptrcmp( char *x , 
                char *y ) 
{
    return ( (int)*x - (int)*y );
}


/*****************/
/*  st_init_gen  */
/*****************/

st_generator *st_init_gen( st_table *table ) 

/* Initializes generation of items in table */
{
    st_generator *gen;

    gen = alloc(st_generator);

    if (!gen) {
	errRaise(st_pkg_name, ST_NO_MEM, st_no_mem);
	/* NOTREACHED */
    }

    gen->table = table;
    gen->entry = nil(st_table_entry);
    gen->idx = 0;

    return gen;
}



/************/
/*  st_gen  */
/************/

int st_gen( st_generator *gen      , 
            char         **key_p   , 
            char         **value_p ) 

/* Generates next item in generation sequence */
{
    register int i;

    if (!gen) {
	errRaise(st_pkg_name, ST_BAD_GEN, st_bad_gen);
	/* NOTREACHED */
    }

    if (gen->entry == nil(st_table_entry)) {
	/* try to find next entry */
	for (i = gen->idx; i < gen->table->num_bins; i++) {
	    if (gen->table->bins[i] != nil(st_table_entry)) {
		gen->idx = i + 1;
		gen->entry = gen->table->bins[i];
		break;
	    }
	}
	if (gen->entry == nil(st_table_entry)) {
	    return 0;		/* that's all folks ! */
	}
    }

    *key_p = gen->entry->key;

    if (value_p != 0)
	*value_p = gen->entry->record;
    gen->entry = gen->entry->next;

    return 1;
}



/*****************/
/*  st_Free_gen  */
/*****************/

void st_Free_gen( st_generator *gen ) 
{
    if (gen) {
	Free((char *) gen);
    }
    else {
	errRaise(st_pkg_name, ST_BAD_GEN, st_bad_gen);
	/* NOTREACHED */
    }
}



/**************/
/*  errRaise  */
/**************/

void  errRaise( char *pkg , 
                int  num  , 
                char *msg ) 

/*
 * In this standalone version of st, and error raise causes
 * an abort after printing a message.
 */
{
    (void) fprintf(stderr, "%s: %s\n", pkg, msg);
    abort();
}

#ifndef HEADER_H
#define HEADER_H

const char header_str[] = "\
/*\n\
   The latest version of this library is available on GitHub;\n\
   https://github.com/sheredom/hashmap.h\n\
*/\n\
\n\
/*\n\
   This is free and unencumbered software released into the public domain.\n\
\n\
   Anyone is free to copy, modify, publish, use, compile, sell, or\n\
   distribute this software, either in source code form or as a compiled\n\
   binary, for any purpose, commercial or non-commercial, and by any\n\
   means.\n\
\n\
   In jurisdictions that recognize copyright laws, the author or authors\n\
   of this software dedicate any and all copyright interest in the\n\
   software to the public domain. We make this dedication for the benefit\n\
   of the public at large and to the detriment of our heirs and\n\
   successors. We intend this dedication to be an overt act of\n\
   relinquishment in perpetuity of all present and future rights to this\n\
   software under copyright law.\n\
\n\
   THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,\n\
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n\
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n\
   IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR\n\
   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,\n\
   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR\n\
   OTHER DEALINGS IN THE SOFTWARE.\n\
\n\
   For more information, please refer to <http://unlicense.org/>\n\
*/\n\
#ifndef SHEREDOM_HASHMAP_H_INCLUDED\n\
#define SHEREDOM_HASHMAP_H_INCLUDED\n\
\n\
#if defined(_MSC_VER)\n\
// Workaround a bug in the MSVC runtime where it uses __cplusplus when not\n\
// defined.\n\
#pragma warning(push, 0)\n\
#pragma warning(disable : 4668)\n\
#endif\n\
#include <stdlib.h>\n\
#include <string.h>\n\
\n\
#if (defined(_MSC_VER) && defined(__AVX__)) ||                                 \\  \n\
    (!defined(_MSC_VER) && defined(__SSE4_2__))\n\
#define HASHMAP_SSE42\n\
#endif\n\
\n\
#if defined(HASHMAP_SSE42)\n\
#include <nmmintrin.h>\n\
#endif\n\
\n\
#if defined(_MSC_VER)\n\
#pragma warning(pop)\n\
#endif\n\
\n\
#if defined(_MSC_VER)\n\
#pragma warning(push)\n\
/* Stop MSVC complaining about unreferenced functions */\n\
#pragma warning(disable : 4505)\n\
/* Stop MSVC complaining about not inlining functions */\n\
#pragma warning(disable : 4710)\n\
/* Stop MSVC complaining about inlining functions! */\n\
#pragma warning(disable : 4711)\n\
#elif defined(__clang__)\n\
#pragma clang diagnostic push\n\
#pragma clang diagnostic ignored \"-Wunused-function\"\n\
#endif\n\
\n\
#if defined(_MSC_VER)\n\
#define HASHMAP_USED\n\
#elif defined(__GNUC__)\n\
#define HASHMAP_USED __attribute__((used))\n\
#else\n\
#define HASHMAP_USED\n\
#endif\n\
\n\
/* We need to keep keys and values. */\n\
struct hashmap_element_s\n\
{\n\
    const char *key;\n\
    unsigned key_len;\n\
    int in_use;\n\
    void *data;\n\
};\n\
\n\
/* A hashmap has some maximum size and current size, as well as the data to\n\
 * hold. */\n\
struct hashmap_s\n\
{\n\
    unsigned table_size;\n\
    unsigned size;\n\
    struct hashmap_element_s *data;\n\
};\n\
\n\
#define HASHMAP_MAX_CHAIN_LENGTH (8)\n\
\n\
#if defined(__cplusplus)\n\
extern \"C\"\n\
{\n\
#endif\n\
\n\
    /// @brief Create a hashmap.\n\
    /// @param initial_size The initial size of the hashmap. Must be a power of two.\n\
    /// @param out_hashmap The storage for the created hashmap.\n\
    /// @return On success 0 is returned.\n\
    ///\n\
    /// Note that the initial size of the hashmap must be a power of two, and\n\
    /// creation of the hashmap will fail if this is not the case.\n\
    static int hashmap_create(const unsigned initial_size,\n\
                              struct hashmap_s *const out_hashmap) HASHMAP_USED;\n\
\n\
    /// @brief Put an element into the hashmap.\n\
    /// @param hashmap The hashmap to insert into.\n\
    /// @param key The string key to use.\n\
    /// @param len The length of the string key.\n\
    /// @param value The value to insert.\n\
    /// @return On success 0 is returned.\n\
    ///\n\
    /// The key string slice is not copied when creating the hashmap entry, and thus\n\
    /// must remain a valid pointer until the hashmap entry is removed or the\n\
    /// hashmap is destroyed.\n\
    static int hashmap_put(struct hashmap_s *const hashmap, const char *const key,\n\
                           const unsigned len, void *const value) HASHMAP_USED;\n\
\n\
    /// @brief Get an element from the hashmap.\n\
    /// @param hashmap The hashmap to get from.\n\
    /// @param key The string key to use.\n\
    /// @param len The length of the string key.\n\
    /// @return The previously set element, or NULL if none exists.\n\
    static void *hashmap_get(const struct hashmap_s *const hashmap,\n\
                             const char *const key,\n\
                             const unsigned len) HASHMAP_USED;\n\
\n\
    /// @brief Remove an element from the hashmap.\n\
    /// @param hashmap The hashmap to remove from.\n\
    /// @param key The string key to use.\n\
    /// @param len The length of the string key.\n\
    /// @return On success 0 is returned.\n\
    static int hashmap_remove(struct hashmap_s *const hashmap,\n\
                              const char *const key,\n\
                              const unsigned len) HASHMAP_USED;\n\
\n\
    /// @brief Remove an element from the hashmap.\n\
    /// @param hashmap The hashmap to remove from.\n\
    /// @param key The string key to use.\n\
    /// @param len The length of the string key.\n\
    /// @return On success the original stored key pointer is returned, on failure\n\
    /// NULL is returned.\n\
    static const char *\n\
    hashmap_remove_and_return_key(struct hashmap_s *const hashmap,\n\
                                  const char *const key,\n\
                                  const unsigned len) HASHMAP_USED;\n\
\n\
    /// @brief Iterate over all the elements in a hashmap.\n\
    /// @param hashmap The hashmap to iterate over.\n\
    /// @param f The function pointer to call on each element.\n\
    /// @param context The context to pass as the first argument to f.\n\
    /// @return If the entire hashmap was iterated then 0 is returned. Otherwise if\n\
    /// the callback function f returned non-zero then non-zero is returned.\n\
    static int hashmap_iterate(const struct hashmap_s *const hashmap,\n\
                               int (*f)(void *const context, void *const value),\n\
                               void *const context) HASHMAP_USED;\n\
\n\
    /// @brief Iterate over all the elements in a hashmap.\n\
    /// @param hashmap The hashmap to iterate over.\n\
    /// @param f The function pointer to call on each element.\n\
    /// @param context The context to pass as the first argument to f.\n\
    /// @return If the entire hashmap was iterated then 0 is returned.\n\
    /// Otherwise if the callback function f returned positive then the positive\n\
    /// value is returned.  If the callback function returns -1, the current item\n\
    /// is removed and iteration continues.\n\
    static int hashmap_iterate_pairs(struct hashmap_s *const hashmap,\n\
                                     int (*f)(void *const,\n\
                                              struct hashmap_element_s *const),\n\
                                     void *const context) HASHMAP_USED;\n\
\n\
    /// @brief Get the size of the hashmap.\n\
    /// @param hashmap The hashmap to get the size of.\n\
    /// @return The size of the hashmap.\n\
    static unsigned\n\
    hashmap_num_entries(const struct hashmap_s *const hashmap) HASHMAP_USED;\n\
\n\
    /// @brief Destroy the hashmap.\n\
    /// @param hashmap The hashmap to destroy.\n\
    static void hashmap_destroy(struct hashmap_s *const hashmap) HASHMAP_USED;\n\
\n\
    static unsigned hashmap_crc32_helper(const char *const s,\n\
                                         const unsigned len) HASHMAP_USED;\n\
    static unsigned hashmap_hash_helper_int_helper(const struct hashmap_s *const m,\n\
                                                   const char *const keystring,\n\
                                                   const unsigned len) HASHMAP_USED;\n\
    static int hashmap_match_helper(const struct hashmap_element_s *const element,\n\
                                    const char *const key,\n\
                                    const unsigned len) HASHMAP_USED;\n\
    static int hashmap_hash_helper(const struct hashmap_s *const m,\n\
                                   const char *const key, const unsigned len,\n\
                                   unsigned *const out_index) HASHMAP_USED;\n\
    static int\n\
    hashmap_rehash_iterator(void *const new_hash,\n\
                            struct hashmap_element_s *const e) HASHMAP_USED;\n\
    static int hashmap_rehash_helper(struct hashmap_s *const m) HASHMAP_USED;\n\
\n\
#if defined(__cplusplus)\n\
}\n\
#endif\n\
\n\
#if defined(__cplusplus)\n\
#define HASHMAP_CAST(type, x) static_cast<type>(x)\n\
#define HASHMAP_PTR_CAST(type, x) reinterpret_cast<type>(x)\n\
#define HASHMAP_NULL NULL\n\
#else\n\
#define HASHMAP_CAST(type, x) ((type)x)\n\
#define HASHMAP_PTR_CAST(type, x) ((type)x)\n\
#define HASHMAP_NULL 0\n\
#endif\n\
\n\
int hashmap_create(const unsigned initial_size,\n\
                   struct hashmap_s *const out_hashmap)\n\
{\n\
    out_hashmap->table_size = initial_size;\n\
    out_hashmap->size = 0;\n\
\n\
    if (0 == initial_size || 0 != (initial_size & (initial_size - 1)))\n\
    {\n\
        return 1;\n\
    }\n\
\n\
    out_hashmap->data =\n\
        HASHMAP_CAST(struct hashmap_element_s *,\n\
                     calloc(initial_size, sizeof(struct hashmap_element_s)));\n\
    if (!out_hashmap->data)\n\
    {\n\
        return 1;\n\
    }\n\
\n\
    return 0;\n\
}\n\
\n\
int hashmap_put(struct hashmap_s *const m, const char *const key,\n\
                const unsigned len, void *const value)\n\
{\n\
    unsigned int index;\n\
\n\
    /* Find a place to put our value. */\n\
    while (!hashmap_hash_helper(m, key, len, &index))\n\
    {\n\
        if (hashmap_rehash_helper(m))\n\
        {\n\
            return 1;\n\
        }\n\
    }\n\
\n\
    /* Set the data. */\n\
    m->data[index].data = value;\n\
    m->data[index].key = key;\n\
    m->data[index].key_len = len;\n\
\n\
    /* If the hashmap element was not already in use, set that it is being used\n\
     * and bump our size. */\n\
    if (0 == m->data[index].in_use)\n\
    {\n\
        m->data[index].in_use = 1;\n\
        m->size++;\n\
    }\n\
\n\
    return 0;\n\
}\n\
\n\
void *hashmap_get(const struct hashmap_s *const m, const char *const key,\n\
                  const unsigned len)\n\
{\n\
    unsigned int curr;\n\
    unsigned int i;\n\
\n\
    /* Find data location */\n\
    curr = hashmap_hash_helper_int_helper(m, key, len);\n\
\n\
    /* Linear probing, if necessary */\n\
    for (i = 0; i < HASHMAP_MAX_CHAIN_LENGTH; i++)\n\
    {\n\
        if (m->data[curr].in_use)\n\
        {\n\
            if (hashmap_match_helper(&m->data[curr], key, len))\n\
            {\n\
                return m->data[curr].data;\n\
            }\n\
        }\n\
\n\
        curr = (curr + 1) % m->table_size;\n\
    }\n\
\n\
    /* Not found */\n\
    return HASHMAP_NULL;\n\
}\n\
\n\
int hashmap_remove(struct hashmap_s *const m, const char *const key,\n\
                   const unsigned len)\n\
{\n\
    unsigned int i;\n\
    unsigned int curr;\n\
\n\
    /* Find key */\n\
    curr = hashmap_hash_helper_int_helper(m, key, len);\n\
\n\
    /* Linear probing, if necessary */\n\
    for (i = 0; i < HASHMAP_MAX_CHAIN_LENGTH; i++)\n\
    {\n\
        if (m->data[curr].in_use)\n\
        {\n\
            if (hashmap_match_helper(&m->data[curr], key, len))\n\
            {\n\
                /* Blank out the fields including in_use */\n\
                memset(&m->data[curr], 0, sizeof(struct hashmap_element_s));\n\
\n\
                /* Reduce the size */\n\
                m->size--;\n\
\n\
                return 0;\n\
            }\n\
        }\n\
\n\
        curr = (curr + 1) % m->table_size;\n\
    }\n\
\n\
    return 1;\n\
}\n\
\n\
const char *hashmap_remove_and_return_key(struct hashmap_s *const m,\n\
                                          const char *const key,\n\
                                          const unsigned len)\n\
{\n\
    unsigned int i;\n\
    unsigned int curr;\n\
\n\
    /* Find key */\n\
    curr = hashmap_hash_helper_int_helper(m, key, len);\n\
\n\
    /* Linear probing, if necessary */\n\
    for (i = 0; i < HASHMAP_MAX_CHAIN_LENGTH; i++)\n\
    {\n\
        if (m->data[curr].in_use)\n\
        {\n\
            if (hashmap_match_helper(&m->data[curr], key, len))\n\
            {\n\
                const char *const stored_key = m->data[curr].key;\n\
\n\
                /* Blank out the fields */\n\
                m->data[curr].in_use = 0;\n\
                m->data[curr].data = HASHMAP_NULL;\n\
                m->data[curr].key = HASHMAP_NULL;\n\
\n\
                /* Reduce the size */\n\
                m->size--;\n\
\n\
                return stored_key;\n\
            }\n\
        }\n\
        curr = (curr + 1) % m->table_size;\n\
    }\n\
\n\
    return HASHMAP_NULL;\n\
}\n\
\n\
int hashmap_iterate(const struct hashmap_s *const m,\n\
                    int (*f)(void *const, void *const), void *const context)\n\
{\n\
    unsigned int i;\n\
\n\
    /* Linear probing */\n\
    for (i = 0; i < m->table_size; i++)\n\
    {\n\
        if (m->data[i].in_use)\n\
        {\n\
            if (!f(context, m->data[i].data))\n\
            {\n\
                return 1;\n\
            }\n\
        }\n\
    }\n\
    return 0;\n\
}\n\
\n\
int hashmap_iterate_pairs(struct hashmap_s *const hashmap,\n\
                          int (*f)(void *const,\n\
                                   struct hashmap_element_s *const),\n\
                          void *const context)\n\
{\n\
    unsigned int i;\n\
    struct hashmap_element_s *p;\n\
    int r;\n\
\n\
    /* Linear probing */\n\
    for (i = 0; i < hashmap->table_size; i++)\n\
    {\n\
        p = &hashmap->data[i];\n\
        if (p->in_use)\n\
        {\n\
            r = f(context, p);\n\
            switch (r)\n\
            {\n\
            case -1: /* remove item */\n\
                memset(p, 0, sizeof(struct hashmap_element_s));\n\
                hashmap->size--;\n\
                break;\n\
            case 0: /* continue iterating */\n\
                break;\n\
            default: /* early exit */\n\
                return 1;\n\
            }\n\
        }\n\
    }\n\
    return 0;\n\
}\n\
\n\
void hashmap_destroy(struct hashmap_s *const m)\n\
{\n\
    free(m->data);\n\
    memset(m, 0, sizeof(struct hashmap_s));\n\
}\n\
\n\
unsigned hashmap_num_entries(const struct hashmap_s *const m)\n\
{\n\
    return m->size;\n\
}\n\
\n\
unsigned hashmap_crc32_helper(const char *const s, const unsigned len)\n\
{\n\
    unsigned i;\n\
    unsigned crc32val = 0;\n\
\n\
#if defined(HASHMAP_SSE42)\n\
    for (i = 0; i < len; i++)\n\
    {\n\
        crc32val = _mm_crc32_u8(crc32val, HASHMAP_CAST(unsigned char, s[i]));\n\
    }\n\
\n\
    return crc32val;\n\
#else\n\
    // Using polynomial 0x11EDC6F41 to match SSE 4.2's crc function.\n\
    static const unsigned crc32_tab[] = {\n\
        0x00000000U, 0xF26B8303U, 0xE13B70F7U, 0x1350F3F4U, 0xC79A971FU,\n\
        0x35F1141CU, 0x26A1E7E8U, 0xD4CA64EBU, 0x8AD958CFU, 0x78B2DBCCU,\n\
        0x6BE22838U, 0x9989AB3BU, 0x4D43CFD0U, 0xBF284CD3U, 0xAC78BF27U,\n\
        0x5E133C24U, 0x105EC76FU, 0xE235446CU, 0xF165B798U, 0x030E349BU,\n\
        0xD7C45070U, 0x25AFD373U, 0x36FF2087U, 0xC494A384U, 0x9A879FA0U,\n\
        0x68EC1CA3U, 0x7BBCEF57U, 0x89D76C54U, 0x5D1D08BFU, 0xAF768BBCU,\n\
        0xBC267848U, 0x4E4DFB4BU, 0x20BD8EDEU, 0xD2D60DDDU, 0xC186FE29U,\n\
        0x33ED7D2AU, 0xE72719C1U, 0x154C9AC2U, 0x061C6936U, 0xF477EA35U,\n\
        0xAA64D611U, 0x580F5512U, 0x4B5FA6E6U, 0xB93425E5U, 0x6DFE410EU,\n\
        0x9F95C20DU, 0x8CC531F9U, 0x7EAEB2FAU, 0x30E349B1U, 0xC288CAB2U,\n\
        0xD1D83946U, 0x23B3BA45U, 0xF779DEAEU, 0x05125DADU, 0x1642AE59U,\n\
        0xE4292D5AU, 0xBA3A117EU, 0x4851927DU, 0x5B016189U, 0xA96AE28AU,\n\
        0x7DA08661U, 0x8FCB0562U, 0x9C9BF696U, 0x6EF07595U, 0x417B1DBCU,\n\
        0xB3109EBFU, 0xA0406D4BU, 0x522BEE48U, 0x86E18AA3U, 0x748A09A0U,\n\
        0x67DAFA54U, 0x95B17957U, 0xCBA24573U, 0x39C9C670U, 0x2A993584U,\n\
        0xD8F2B687U, 0x0C38D26CU, 0xFE53516FU, 0xED03A29BU, 0x1F682198U,\n\
        0x5125DAD3U, 0xA34E59D0U, 0xB01EAA24U, 0x42752927U, 0x96BF4DCCU,\n\
        0x64D4CECFU, 0x77843D3BU, 0x85EFBE38U, 0xDBFC821CU, 0x2997011FU,\n\
        0x3AC7F2EBU, 0xC8AC71E8U, 0x1C661503U, 0xEE0D9600U, 0xFD5D65F4U,\n\
        0x0F36E6F7U, 0x61C69362U, 0x93AD1061U, 0x80FDE395U, 0x72966096U,\n\
        0xA65C047DU, 0x5437877EU, 0x4767748AU, 0xB50CF789U, 0xEB1FCBADU,\n\
        0x197448AEU, 0x0A24BB5AU, 0xF84F3859U, 0x2C855CB2U, 0xDEEEDFB1U,\n\
        0xCDBE2C45U, 0x3FD5AF46U, 0x7198540DU, 0x83F3D70EU, 0x90A324FAU,\n\
        0x62C8A7F9U, 0xB602C312U, 0x44694011U, 0x5739B3E5U, 0xA55230E6U,\n\
        0xFB410CC2U, 0x092A8FC1U, 0x1A7A7C35U, 0xE811FF36U, 0x3CDB9BDDU,\n\
        0xCEB018DEU, 0xDDE0EB2AU, 0x2F8B6829U, 0x82F63B78U, 0x709DB87BU,\n\
        0x63CD4B8FU, 0x91A6C88CU, 0x456CAC67U, 0xB7072F64U, 0xA457DC90U,\n\
        0x563C5F93U, 0x082F63B7U, 0xFA44E0B4U, 0xE9141340U, 0x1B7F9043U,\n\
        0xCFB5F4A8U, 0x3DDE77ABU, 0x2E8E845FU, 0xDCE5075CU, 0x92A8FC17U,\n\
        0x60C37F14U, 0x73938CE0U, 0x81F80FE3U, 0x55326B08U, 0xA759E80BU,\n\
        0xB4091BFFU, 0x466298FCU, 0x1871A4D8U, 0xEA1A27DBU, 0xF94AD42FU,\n\
        0x0B21572CU, 0xDFEB33C7U, 0x2D80B0C4U, 0x3ED04330U, 0xCCBBC033U,\n\
        0xA24BB5A6U, 0x502036A5U, 0x4370C551U, 0xB11B4652U, 0x65D122B9U,\n\
        0x97BAA1BAU, 0x84EA524EU, 0x7681D14DU, 0x2892ED69U, 0xDAF96E6AU,\n\
        0xC9A99D9EU, 0x3BC21E9DU, 0xEF087A76U, 0x1D63F975U, 0x0E330A81U,\n\
        0xFC588982U, 0xB21572C9U, 0x407EF1CAU, 0x532E023EU, 0xA145813DU,\n\
        0x758FE5D6U, 0x87E466D5U, 0x94B49521U, 0x66DF1622U, 0x38CC2A06U,\n\
        0xCAA7A905U, 0xD9F75AF1U, 0x2B9CD9F2U, 0xFF56BD19U, 0x0D3D3E1AU,\n\
        0x1E6DCDEEU, 0xEC064EEDU, 0xC38D26C4U, 0x31E6A5C7U, 0x22B65633U,\n\
        0xD0DDD530U, 0x0417B1DBU, 0xF67C32D8U, 0xE52CC12CU, 0x1747422FU,\n\
        0x49547E0BU, 0xBB3FFD08U, 0xA86F0EFCU, 0x5A048DFFU, 0x8ECEE914U,\n\
        0x7CA56A17U, 0x6FF599E3U, 0x9D9E1AE0U, 0xD3D3E1ABU, 0x21B862A8U,\n\
        0x32E8915CU, 0xC083125FU, 0x144976B4U, 0xE622F5B7U, 0xF5720643U,\n\
        0x07198540U, 0x590AB964U, 0xAB613A67U, 0xB831C993U, 0x4A5A4A90U,\n\
        0x9E902E7BU, 0x6CFBAD78U, 0x7FAB5E8CU, 0x8DC0DD8FU, 0xE330A81AU,\n\
        0x115B2B19U, 0x020BD8EDU, 0xF0605BEEU, 0x24AA3F05U, 0xD6C1BC06U,\n\
        0xC5914FF2U, 0x37FACCF1U, 0x69E9F0D5U, 0x9B8273D6U, 0x88D28022U,\n\
        0x7AB90321U, 0xAE7367CAU, 0x5C18E4C9U, 0x4F48173DU, 0xBD23943EU,\n\
        0xF36E6F75U, 0x0105EC76U, 0x12551F82U, 0xE03E9C81U, 0x34F4F86AU,\n\
        0xC69F7B69U, 0xD5CF889DU, 0x27A40B9EU, 0x79B737BAU, 0x8BDCB4B9U,\n\
        0x988C474DU, 0x6AE7C44EU, 0xBE2DA0A5U, 0x4C4623A6U, 0x5F16D052U,\n\
        0xAD7D5351U};\n\
\n\
    for (i = 0; i < len; i++)\n\
    {\n\
        crc32val = crc32_tab[(HASHMAP_CAST(unsigned char, crc32val) ^\n\
                              HASHMAP_CAST(unsigned char, s[i]))] ^\n\
                   (crc32val >> 8);\n\
    }\n\
    return crc32val;\n\
#endif\n\
}\n\
\n\
unsigned hashmap_hash_helper_int_helper(const struct hashmap_s *const m,\n\
                                        const char *const keystring,\n\
                                        const unsigned len)\n\
{\n\
    unsigned key = hashmap_crc32_helper(keystring, len);\n\
\n\
    /* Robert Jenkins' 32 bit Mix Function */\n\
    key += (key << 12);\n\
    key ^= (key >> 22);\n\
    key += (key << 4);\n\
    key ^= (key >> 9);\n\
    key += (key << 10);\n\
    key ^= (key >> 2);\n\
    key += (key << 7);\n\
    key ^= (key >> 12);\n\
\n\
    /* Knuth's Multiplicative Method */\n\
    key = (key >> 3) * 2654435761;\n\
\n\
    return key % m->table_size;\n\
}\n\
\n\
int hashmap_match_helper(const struct hashmap_element_s *const element,\n\
                         const char *const key, const unsigned len)\n\
{\n\
    return (element->key_len == len) && (0 == memcmp(element->key, key, len));\n\
}\n\
\n\
int hashmap_hash_helper(const struct hashmap_s *const m, const char *const key,\n\
                        const unsigned len, unsigned *const out_index)\n\
{\n\
    unsigned int start, curr;\n\
    unsigned int i;\n\
    int total_in_use;\n\
\n\
    /* If full, return immediately */\n\
    if (m->size >= m->table_size)\n\
    {\n\
        return 0;\n\
    }\n\
\n\
    /* Find the best index */\n\
    curr = start = hashmap_hash_helper_int_helper(m, key, len);\n\
\n\
    /* First linear probe to check if we've already insert the element */\n\
    total_in_use = 0;\n\
\n\
    for (i = 0; i < HASHMAP_MAX_CHAIN_LENGTH; i++)\n\
    {\n\
        const int in_use = m->data[curr].in_use;\n\
\n\
        total_in_use += in_use;\n\
\n\
        if (in_use && hashmap_match_helper(&m->data[curr], key, len))\n\
        {\n\
            *out_index = curr;\n\
            return 1;\n\
        }\n\
\n\
        curr = (curr + 1) % m->table_size;\n\
    }\n\
\n\
    curr = start;\n\
\n\
    /* Second linear probe to actually insert our element (only if there was at\n\
     * least one empty entry) */\n\
    if (HASHMAP_MAX_CHAIN_LENGTH > total_in_use)\n\
    {\n\
        for (i = 0; i < HASHMAP_MAX_CHAIN_LENGTH; i++)\n\
        {\n\
            if (!m->data[curr].in_use)\n\
            {\n\
                *out_index = curr;\n\
                return 1;\n\
            }\n\
\n\
            curr = (curr + 1) % m->table_size;\n\
        }\n\
    }\n\
\n\
    return 0;\n\
}\n\
\n\
int hashmap_rehash_iterator(void *const new_hash,\n\
                            struct hashmap_element_s *const e)\n\
{\n\
    int temp = hashmap_put(HASHMAP_PTR_CAST(struct hashmap_s *, new_hash), e->key,\n\
                           e->key_len, e->data);\n\
    if (0 < temp)\n\
    {\n\
        return 1;\n\
    }\n\
    /* clear old value to avoid stale pointers */\n\
    return -1;\n\
}\n\
/*\n\
 * Doubles the size of the hashmap, and rehashes all the elements\n\
 */\n\
int hashmap_rehash_helper(struct hashmap_s *const m)\n\
{\n\
    /* If this multiplication overflows hashmap_create will fail. */\n\
    unsigned new_size = 2 * m->table_size;\n\
\n\
    struct hashmap_s new_hash;\n\
\n\
    int flag = hashmap_create(new_size, &new_hash);\n\
\n\
    if (0 != flag)\n\
    {\n\
        return flag;\n\
    }\n\
\n\
    /* copy the old elements to the new table */\n\
    flag = hashmap_iterate_pairs(m, hashmap_rehash_iterator,\n\
                                 HASHMAP_PTR_CAST(void *, &new_hash));\n\
\n\
    if (0 != flag)\n\
    {\n\
        return flag;\n\
    }\n\
\n\
    hashmap_destroy(m);\n\
    /* put new hash into old hash structure by copying */\n\
    memcpy(m, &new_hash, sizeof(struct hashmap_s));\n\
\n\
    return 0;\n\
}\n\
\n\
#if defined(_MSC_VER)\n\
#pragma warning(pop)\n\
#elif defined(__clang__)\n\
#pragma clang diagnostic pop\n\
#endif\n\
\n\
#endif\n\
";

#endif // HEADER_H
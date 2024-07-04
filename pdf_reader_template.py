import os
import pypdf
import re
import sys
import csv

# filename depends on location
#FILENAME = '250-372 2023-10-12 19-20-55_SI.pdf'#cloud
FILENAME = 'GC_RESULT.pdf'#lab
#"C:\Users\rhade\Downloads\250-372 2023-10-12 19-20-55_SI.pdf"
# python camrslt.py C:\Users\rhade\Downloads
#py "C:\Users\A3T2YZZ\OneDrive - 3M\Desktop\pdf_reader_template.py" "M:\114320 Quality Assur\Quality\Common folder\GC"
# "M:\114320 Quality Assur\Quality\Common folder\GC"
# GC_RESULT.pdf
def main():
    path = ''
    if len(sys.argv) == 2:
        path = sys.argv[1]
        if path == 'test'.casefold():
            path = './'
    if len(sys.argv) == 3:
        full_path = sys.argv[2]

#os.chdir('\\\\usfile01\\us-ac-common\\114320 Quality Assur\\Quality')
#pdf_object = pypdf.PdfReader('FE5622Q 30354.pdf')
# Something worked, but I don't know exactly which.
# os.path.abspath(\\usfile01\us-ac-common\114320 Quality Assur\Quality\ISO 9001-2000 Cert 92203.pdf)
# os.getcwd()
# '\\\\usfile01\\us-ac-common\\114320 Quality Assur\\Quality'
#number_of_pages = len(pdf_object.pages)
#>>> number_of_pages
#1
#page_one = pdf_object.pages[0]
#text = page_one.extract_text()
#print(text)
    product_code, lot_number, date_time, column_headers, rslts = get_GC_result(path)
    headers = {'product_code': product_code, 'lot_number': lot_number, 'date_time': date_time}
    sliced_results = slice_results(rslts)
    #make dict

    results = {'rslts': rslts}
    output_results_to_csv(sliced_results)
    # print(product_code)
    # print(lot_number)
    # print(rslts)
    #input("Press Enter to end:")


def get_GC_result(syspath = ''):
    if syspath == '':
        common_drive_path ='M:\\114320 Quality Assur\\Quality\\Common folder\\GC'
    else:
        common_drive_path = syspath
    os.chdir(common_drive_path)
    # Open GC file
    gc_pdf = pypdf.PdfReader(FILENAME)
    date_time, rslts = [], []
    sample_info = None #find_sample_info(gc_pdf)
    product_code = None #get_product_code(sample_info)#produces AttributeError cam8
    lot_number = None #get_lot_number(sample_info)#untestes
    rslts = find_final(gc_pdf)#35
    rslts = purify_results(rslts) #28
    column_headers = find_column_headers(rslts)
    rslts = purify_results_2(column_headers, rslts) #81

    '''
    # Print pdf page.
    for current_page in range(len(gc_pdf.pages)):
        text = gc_pdf.pages[current_page].extract_text()
        date_time.append(get_date_time(text))
        print(text)
    input()
    '''
    return (product_code, lot_number, date_time, column_headers, rslts)
    #return (sample_info, lot_number, date_time, rslts)
# Finds line with Sample Info and returns that line.

def find_sample_info(gc_pdf):
    number_of_pages = len(gc_pdf.pages)
    for current_page in range(number_of_pages):
        smpl_nfo = get_sample_info(gc_pdf.pages[current_page].extract_text())
        if smpl_nfo:
            return smpl_nfo
    return 'Product code not found'


def get_sample_info(page):
    page = convert_page_to_lines(page)
    pc = []
    for line in page:
        # Check each line for product code
        line = str(line)
        if re.search('[rR]\s*-\s*\d{5}',line):
            return line
    return None


def get_product_code(smpl_nfo):
    pc = re.search('[rR]\s*-\s*\d{5}',smpl_nfo)
    return str(pc.group(0))


def get_lot_number(smpl_nfo):
    lot_no = re.search('[\s/]+\d{5}',smpl_nfo)
    lot_no = str(lot_no.group(0))
    lot_no = lot_no.strip()
    lot_no = lot_no.strip('/')
    lot_no = lot_no.strip()
    return lot_no


def convert_page_to_lines(page):
    lines = []
    words = ''
    for char_on_page in page:
        if char_on_page != '\n':
            words += char_on_page
        else:
            lines.append(words)
            words = ''
    return lines


def find_final(gc_pdf):
    # Pass in entire pdf
    # Get number of pages
    number_of_pages = len(gc_pdf.pages)
    # Iterate through pdf, line by line until final report is found
    found = False
    all_results = []
    for current_page in range(number_of_pages):
        page_in_chars = gc_pdf.pages[current_page].extract_text()
        page_in_lines = convert_page_to_lines(page_in_chars)
        for i in range (len(page_in_lines)):
            #If true, append line, if not true look for fin
            if found:
                all_results.append(page_in_lines[i])
            else:
                if 'Final Summed Pea' in page_in_lines[i]:
                    found = True
    return all_results


# Get rid of lines not consisting of results
def purify_results(rslts):
    rslts = remove_matching('ample', rslts)
    rslts = remove_matching('===', rslts)
    rslts = remove_matching('ignal', rslts)
    rslts = remove_matching('pA*s', rslts)
    rslts = remove_matching('---', rslts)
    rslts = remove_matching('eport', rslts)
    rslts = remove_matching('otals', rslts)
    #rslts = remove_matching('SIG', rslts)
    return rslts


def remove_matching(removal_str, rslts):
    new_results2 = []
    for line in rslts:
        if removal_str not in line:
            new_results2.append(line)
    return new_results2


def get_date_time(text):
    return None


def find_column_headers(r):
    col_hed = []
    for entry in r[0].split('  '):
        if entry != '':
            col_hed.append(entry)
    return col_hed


# Remove all instances of headers from results.
#rslts = purify_results_2(column_headers, rslts)
def purify_results_2(column_headers, rslts):
    results = []
    #for header in column_headers:
    for line in rslts:
        if column_headers[0] not in line and column_headers[1] not in line and column_headers[2] not in line:
            results.append(line)
    return results

#['35'] for each line, slice 1 and slice 2  in 2d array, slice 1 == name slice 2 ==value:
def  slice_results(rslts):
    result_key = []
    result_value = []
    result_fullset = []
    for line in rslts:
        result_key.append(line[:15].strip())
        result_value.append(line[27:].strip())
        result_fullset.append(line[:15].strip()+' ; '+line[27:].strip())        
    return result_fullset


#output_results_to_csv(results)
def output_results_to_csv(results):
    with open('gc_results.csv', 'w', newline='') as csvfile:
        spamwriter = csv.writer(csvfile)
        spamwriter.writerow(results)
        '''
        for row in results:
            spamwriter.writerow(results)
            '''


if __name__ == '__main__':
    main()
